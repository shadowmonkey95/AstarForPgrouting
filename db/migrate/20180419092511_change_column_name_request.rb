class ChangeColumnNameRequest < ActiveRecord::Migration[5.1]
  def change
    rename_column :requests, :destination_address, :address
  end
end
