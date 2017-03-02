class CreateCartItems < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_items do |t|
      t.integer :product_id
      t.integer :order_id
      t.float   :price
      t.integer :quantity

      t.timestamps
    end
  end
end
