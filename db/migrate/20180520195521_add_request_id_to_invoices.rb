class AddRequestIdToInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :request_id, :integer
  end
end
