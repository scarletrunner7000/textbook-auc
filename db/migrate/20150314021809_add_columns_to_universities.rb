class AddColumnsToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :name, :string
    add_column :universities, :kana, :string
  end
end
