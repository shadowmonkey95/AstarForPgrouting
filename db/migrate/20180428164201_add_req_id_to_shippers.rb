class AddReqIdToShippers < ActiveRecord::Migration[5.1]
  def change
    add_column :shippers, :req_id, :string
  end
end
