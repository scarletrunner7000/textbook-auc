class RemoveColumnsFromLectures < ActiveRecord::Migration
  def change
    remove_column :lectures, :teacher, :string
    remove_column :lectures, :day, :integer
    remove_column :lectures, :period, :integer
    remove_column :lectures, :room, :string
    remove_column :lectures, :link_url, :text
  end
end
