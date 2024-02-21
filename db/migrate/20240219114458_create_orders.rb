class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :price, precision: 12, scale: 2, default: 0
      t.integer :quantity
      t.string :order_type
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
