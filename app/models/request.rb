class Request < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  belongs_to :shop, optional: true
end
