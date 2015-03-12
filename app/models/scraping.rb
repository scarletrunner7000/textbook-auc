require 'selenium-webdriver'

class Scraping

  @@NOT_FOUND = "not found"
  @@UNIV_ID_KYOTO = 1

  def self.get
    lec_driver = Selenium::WebDriver.for :chrome
    book_driver = Selenium::WebDriver.for :chrome
    book_driver.manage.timeouts.implicit_wait = 20
    lec_url_list = []

    begin
      lec_driver.navigate.to "http://www.t.kyoto-u.ac.jp/syllabus-s/?mode=book&lang=ja&year=2015&b=5"
      lec_url_list = lec_driver.find_elements(:css, ".subjectlist tr a").map {|lec_a| lec_a.attribute("href")}

      lec_url_list.each do |lec_url|
        lecture_h = {}
        book_h = {}

        if lec_url[-5..-1] == "60120" || lec_url[-5..-1] == "60130" # 論理回路 # 情報理論
          lec_url[/2015/] = "2014"
        end
        puts lec_url
        lec_driver.navigate.to lec_url

        lecture_h[:name] = lec_driver.find_element(:tag_name, "h2").text[/\s:\s.*/][3..-1]
        lec_texts = lec_driver.find_elements(:css, ".basic td").map {|item| item.text}
        if lec_texts[1].length != 2
          lecture_h[:grade] = -1
        else
          lecture_h[:grade] = lec_texts[1].to_i
        end
        lecture_h[:term] = lec_texts[2][7..8]
        if lec_url[-5..-1] == "60120" || lec_url[-5..-1] == "60130" # 論理回路 # 情報理論
          lecture_h[:term] = lec_texts[2]
        end
        lecture_h[:university_id] = @@UNIV_ID_KYOTO

        puts lec_texts[0]
        puts lecture_h[:name]
        puts lecture_h[:grade]
        puts lecture_h[:term]

        book_p = get_text_btw(lec_driver.page_source[/<h3>教科書<\/h3>(.|\n)*/], "<p>", "<\/p>")
        book_link = get_text_btw(book_p, 'href="http://m.kulib.kyoto-u.ac.jp', '"')
        puts book_link
        if (code = book_link[/isbn_issn=.*/]) != nil
          code = code[10..-1]
          book_url = "http://kuline.kulib.kyoto-u.ac.jp/?action=pages_view_main&active_action=v3search_view_main_init&block_id=251&op_param=isbn_issn%3D#{code}&search_mode=detail&lang=japanese"
        elsif (code = book_link[/pkey=.*/]) != nil
          code = code[5..-1]
          book_url = "http://kuline.kulib.kyoto-u.ac.jp/?action=pages_view_main&active_action=v3search_view_main_init&block_id=251&direct_target=catdbl&direct_key="
          i = 0
          while i < code.length
            book_url += "%25" + code[i].ord.to_s(16)
            i += 1
          end
          book_url += "&lang=japanese"
        else
          puts "~~~~~教科書ページなし"
          puts
          next
        end

        puts book_url
        book_driver.navigate.to book_url
        if code == "4121006240" || code == "4785611391"
          book_driver.find_element(:css, "h3.opac_book_title a").click
        end

        book_h[:image_url] = book_driver.find_element(:css, ".opac_book_img img").attribute("src")
        book_driver.find_elements(:css, ".opac_syosi_list tr").each do |syosi_ele|
          if syosi_ele.text[/タイトル／編著者等/] != nil
            td_text = syosi_ele.find_element(:tag_name, "td").text
            book_h[:title] = td_text[/.*\s\/\s/][0..-4]
            book_h[:author] = td_text[/\s\/\s[^(著|\n)]*/][3..-1]
          elsif syosi_ele.text[/ISBN/] != nil
            book_h[:isbn] = syosi_ele.find_element(:css, "table td").text
          end
        end

        puts "*****title = " + book_h[:title]
        puts "*****author= " + book_h[:author]
        puts "*****isbn  = " + book_h[:isbn].to_s
        puts "*****image = " + book_h[:image_url]

        lecture = Lecture.where(university_id: lecture_h[:university_id], name: lecture_h[:name]).first_or_initialize
        lecture.update(lecture_h)
        if book_h[:isbn] == nil
          book = Book.where(title: book_h[:title], author: book_h[:author]).first_or_initialize
        else
          book = Book.where(isbn: book_h[:isbn]).first_or_initialize
        end
        book.update(book_h)
        lecture_book = {lecture_id: lecture.id, book_id: book.id}
        LectureBook.where(lecture_book).first_or_create(lecture_book)

        puts
      end
    ensure
      lec_driver.quit
      book_driver.quit
    end
  end

  private
  def self.get_text_btw(str, s, t)
    if str == nil
      return @@NOT_FOUND
    end
    str = str[/#{s}((?!#{t}).)*#{t}/]
    if str == nil
      return @@NOT_FOUND
    end
    return str[s.length..-1-t.length]
  end

end
