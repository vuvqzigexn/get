class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :origin
      t.string :image_url
      t.integer :user_id
      t.integer :category_id
      t.text :description
      t.integer :stock

      t.timestamps
    end
  end
end
