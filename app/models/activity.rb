class Activity < ApplicationRecord
  self.table_name = "activities"
  scope :unread, ->{where(read_at: nil)}
  belongs_to :recipient, class_name: "User"
  belongs_to :owner, class_name: "User"
  # belongs_to :trackable, polymorphic: true
end
