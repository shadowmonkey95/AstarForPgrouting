class AddTime2ToPaths < ActiveRecord::Migration[5.1]
  def change
    add_column :paths, :time2, :float
  end
end
