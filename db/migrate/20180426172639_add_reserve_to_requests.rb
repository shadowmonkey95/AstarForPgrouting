class AddReserveToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :reserve, :datetime
  end
end
