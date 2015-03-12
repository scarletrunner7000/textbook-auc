class CreateLectureBooks < ActiveRecord::Migration
  def change
    create_table :lecture_books do |t|

      t.timestamps null: false
    end
  end
end
