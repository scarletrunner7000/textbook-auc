class Book < ActiveRecord::Base
  has_many :lecture_books
  has_many :lectures, through: :lecture_books
end
