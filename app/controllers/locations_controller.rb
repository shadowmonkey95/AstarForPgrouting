class LocationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @locations = Location.order('shipper_id ASC').paginate(:page => params[:page], :per_page => 10)
  end

  def setLocation
    pars = params.require(:location).permit(:shipper_id, :latitude, :longtitude, :timestamp)
    shipper_id = pars['shipper_id']
    latitude = pars['latitude']
    longitude = pars['longtitude']
    timestamp = pars['timestamp']
    location = Location.find_by(shipper_id: shipper_id)
    if location
      location.latitude = latitude
      location.longtitude = longitude
      location.timestamp = timestamp
      location.save!
      render json: {
          message: 'success1',
      }, status: :ok
    else
      location = Location.new(pars)
      location.save!
      render json: {
          message: 'success2',
      }, status: :ok
    end

  end

end
