class AddDepositToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :deposit, :integer
  end
end
