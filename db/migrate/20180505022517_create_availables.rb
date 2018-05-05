class CreateAvailables < ActiveRecord::Migration[5.1]
  def change
    create_table :availables do |t|
      t.integer :invoice_id
      t.string :shipper_id

      t.timestamps
    end
  end
end
