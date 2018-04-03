class LocationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index

  end

  def setLocation

    pars = params.require(:location).permit(:shipper_id, :latitude, :longtitude, :timestamp)

    location = Location.new(pars)
    location.save
    render json: {
        message: 'success',
        data: {
            location: location
        }
    }, status: :ok

  end

end
