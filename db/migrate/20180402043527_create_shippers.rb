class CreateShippers < ActiveRecord::Migration[5.1]
  def change
    create_table :shippers do |t|
      t.string :first_name
      t.string :second_name
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
