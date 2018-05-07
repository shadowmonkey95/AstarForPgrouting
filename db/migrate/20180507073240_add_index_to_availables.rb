class AddIndexToAvailables < ActiveRecord::Migration[5.1]
  def change
    add_column :availables, :index, :integer
  end
end
