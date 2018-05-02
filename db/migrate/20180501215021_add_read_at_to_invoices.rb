class AddReadAtToInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :read_at, :datetime
  end
end
