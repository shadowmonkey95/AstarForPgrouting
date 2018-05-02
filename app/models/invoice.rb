class Invoice < ApplicationRecord
  # include PublicActivity::Model
  # tracked
  # @invoice.create_activity key: 'invoice.new'
  after_create_commit {
    InvoiceBroadcastJob.perform_later(Invoice.count, self)}
  validates :shop_id, presence: true
end
