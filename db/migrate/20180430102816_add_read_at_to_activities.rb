class AddReadAtToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :read_at, :datetime
  end
end
