class LocationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @locations = Location.order('shipper_id ASC').paginate(:page => params[:page], :per_page => 10)
  end

  def setLocation

    pars = params.require(:location).permit(:shipper_id, :latitude, :longtitude, :timestamp)

    location = Location.new(pars)
    location.save
    render json: {
        message: 'success',
    }, status: :ok

  end

end
