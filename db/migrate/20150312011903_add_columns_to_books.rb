class AddColumnsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :title, :string
    add_column :books, :author, :string
    add_column :books, :isbn, :integer
    add_column :books, :price, :integer
    add_column :books, :image_url, :text
  end
end
