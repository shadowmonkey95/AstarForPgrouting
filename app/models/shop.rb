class Shop < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  has_many :requests
  belongs_to :user, optional: true
  resourcify
end
