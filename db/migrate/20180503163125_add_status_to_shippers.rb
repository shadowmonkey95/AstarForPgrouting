class AddStatusToShippers < ActiveRecord::Migration[5.1]
  def change
    add_column :shippers, :status, :string
  end
end
