class ChangeColumnNameShop < ActiveRecord::Migration[5.1]
  def change
    rename_column :shops, :lat, :latitude
    rename_column :shops, :lon, :longitude
  end
end
