class LocationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @locations = Location.order('shipper_id ASC').paginate(:page => params[:page], :per_page => 10)
  end

  def create
    location_params = params.require(:location).permit(:shipper_id, :latitude, :longtitude, :timestamp)
    location = Location.new(location_params)
    if location.save
      render json: {
          message: 'success',
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def update
    location_params = params.require(:location).permit(:shipper_id, :latitude, :longtitude, :timestamp)
    location = Location.find_by(shipper_id: location_params['shipper_id'])
    if location.update(location_params)
      render json: {
          message: 'success',
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def setLocation
    pars = params.require(:location).permit(:shipper_id, :latitude, :longtitude, :timestamp)
    location = Location.find_by(shipper_id: pars['shipper_id'])
    if location
      location.latitude = pars['latitude']
      location.longtitude = pars['longtitude']
      location.timestamp = pars['timestamp']
      location.save
      render json: {
          message: 'success',
      }, status: :ok
    else
      location = Location.new(pars)
      location.save
      render json: {
          message: 'success',
      }, status: :ok
    end
  end

end
