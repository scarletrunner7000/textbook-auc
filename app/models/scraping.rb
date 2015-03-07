require 'mechanize'

class Scraping
    # excepts = ['60740']
    # rows = [1, 2, 3, 4, 9]
    # text =[]
    # lecture = {}
    # agent = Mechanize.new
    # idx_page = agent.get('http://www.t.kyoto-u.ac.jp/syllabus-s/?mode=book&lang=ja&year=2015&b=5');
    # lec_elements = idx_page.search('.subjectlist .title a')
    # lec_elements.each do |lec_ele|
    #   lecture[:name] = lec_ele.inner_text
    #   puts lecture[:name]
    #   lec_page = agent.get(lec_ele[:href])
    #   val_elements = lec_page.search('.basic td')
    #   rows.each_with_index do |row, i|
    #     text[i] = val_elements[row].inner_text.strip
    #   end

      text[0] = "3年"
      text[1] = "平成２７年度・前期"
      text[2] = "月曜・1時限"
      text[3] = "電総大"
      text[4] = "工学研究科・教授・引原隆士 （講義内容に合わせて特別講義をお願いすることがあります．）"

      # 学年 text[0]
      if text[0].length == 2
        puts text[0].to_i
      else
        puts "その他"
      end
      # 学期
      puts text[1][7..8]
      # 曜日, 時限
      puts text[2][/[月火水木金]/]
      # 教室
      puts text[3]
      # 担当教員
      puts text[4]

    #   puts
    # end


  end
end
