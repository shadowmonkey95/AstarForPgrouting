class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.integer :shipper_id
      t.string :latitude
      t.string :longtitude
      t.string :timestamp

      t.timestamps
    end
  end
end
