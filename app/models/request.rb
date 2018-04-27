class Request < ApplicationRecord
  geocoded_by :address do |object, results|
    if results.present?
      object.latitude = results.first.latitude
      object.longitude = results.first.longitude
    else
      object.latitude = nil
      object.longitude = nil
    end
  end

  before_validation :geocode, if: :address_changed?

  # validates :address, presence: true
  validate :found_address_presence

  def found_address_presence
    if latitude.blank? || longitude.blank?
      errors.add(:address, "We couldn't find your address, please type it correctly or input longitude and latitude manually")
    end
  end

  # after_validation :geocode

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode

  belongs_to :shop, optional: true
end
