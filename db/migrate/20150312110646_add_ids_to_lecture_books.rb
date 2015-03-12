class AddIdsToLectureBooks < ActiveRecord::Migration
  def change
    add_column :lecture_books, :lecture_id, :integer
    add_column :lecture_books, :book_id, :integer
  end
end
