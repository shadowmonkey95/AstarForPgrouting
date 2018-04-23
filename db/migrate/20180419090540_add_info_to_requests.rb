class AddInfoToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :latitude, :string
    add_column :requests, :longitude, :string
    add_column :requests, :comment, :text
    add_column :requests, :phone, :string
  end
end
