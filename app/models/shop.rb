class Shop < ApplicationRecord
  geocoded_by :address
  after_validation :geocode
  has_many :requests
  belongs_to :user, optional: true
  resourcify
end
