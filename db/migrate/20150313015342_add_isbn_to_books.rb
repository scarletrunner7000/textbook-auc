class AddIsbnToBooks < ActiveRecord::Migration
  def change
    add_column :books, :isbn, :integer, :limit => 8
  end
end
