class Invoice < ApplicationRecord
  include PublicActivity::Model
  # tracked
  # @invoice.create_activity key: 'invoice.new'
end
