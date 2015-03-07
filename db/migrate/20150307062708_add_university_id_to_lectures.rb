class AddUniversityIdToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :university_id, :integer
  end
end
