class Shop < ApplicationRecord
  has_many :requests
  belongs_to :user, optional: true
  resourcify
end
