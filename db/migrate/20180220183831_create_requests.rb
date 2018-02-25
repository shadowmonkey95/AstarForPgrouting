class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.integer :shop_id
      t.string :destination_address
      t.integer :shipper_id
      t.string :status

      t.timestamps
    end
  end
end
