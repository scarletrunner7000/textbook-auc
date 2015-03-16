class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = []
    @lecture = Lecture.new(lecture_tag_params)
    @book = Book.new(book_tag_params)
    if @lecture.grade != nil && @lecture.grade != 0
      @lectures = Lecture.where(grade: @lecture.grade)
    else
      @lectures = Lecture.all
    end
    if @lectures == nil
      return
    end
    @lectures = @lectures.where("name like '%" + @lecture.name.to_s + "%' and term like '%" + @lecture.term.to_s + "%'")
    @lectures.each do |lec_tmp|
      books_tmp = lec_tmp.books
      if @book.isbn.to_s != ""
        books_tmp = books_tmp.where(isbn: @book.isbn)
      end
      @books += books_tmp.where("title like '%" + @book.title.to_s + "%' and author like '%" + @book.author.to_s + "%'")
    end
    @books = @books.uniq
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    # @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author, :isbn, :image_url)
    end
    def lecture_tag_params
      params.permit(:name, :grade, :term, :university_id)
    end
    def book_tag_params
      params.permit(:title, :author, :isbn, :image_url)
    end
end
