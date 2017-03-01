class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.float :total
      t.text :shipping_address
      t.integer :status_id
      t.integer :user_id

      t.timestamps
    end
  end
end
