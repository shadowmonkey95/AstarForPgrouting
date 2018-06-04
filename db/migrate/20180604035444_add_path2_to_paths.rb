class AddPath2ToPaths < ActiveRecord::Migration[5.1]
  def change
    add_column :paths, :path2, :string
  end
end
