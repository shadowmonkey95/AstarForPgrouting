class CreateInvoice < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.integer :shop_id
      t.integer :shipper_id
      t.string :status
      t.float :distance
      t.float :distance2
      t.float :shipping_cost
      t.float :deposit
    end
  end
end
