class RemoveIsbn2FromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :isbn, :integer, :limit => 8
  end
end
