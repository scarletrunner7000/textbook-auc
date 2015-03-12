class Lecture < ActiveRecord::Base
  has_many :lecture_books
  has_many :books, through: :lecture_books
end
