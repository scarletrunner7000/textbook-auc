class CreateBooks2 < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.text :image_url

      t.timestamps null: false
    end
  end
end
