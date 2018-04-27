class CreatePaths < ActiveRecord::Migration[5.1]
  def change
    create_table :paths do |t|
      t.integer :shipper_id
      t.string :path

      t.timestamps
    end
  end
end
