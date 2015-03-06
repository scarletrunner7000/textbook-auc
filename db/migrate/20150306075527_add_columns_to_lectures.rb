class AddColumnsToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :name, :string
    add_column :lectures, :teacher, :string
    add_column :lectures, :grade, :integer
    add_column :lectures, :term, :string
    add_column :lectures, :day, :integer
    add_column :lectures, :period, :integer
    add_column :lectures, :room, :string
    add_column :lectures, :link_url, :text
  end
end
