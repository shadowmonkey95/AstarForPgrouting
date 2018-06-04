class AddDistance2ToPaths < ActiveRecord::Migration[5.1]
  def change
    add_column :paths, :distance2, :float
  end
end
