class PathsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def show
    path = Path.find_by(shipper_id: params[:id])
    if path
      render json: {
          message: 'success',
          data: {
            path: path
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def create
    path_params = params.require(:path).permit(:shipper_id, :path)
    path = Path.new(path_params)
    if path.save
      render json: {
          message: 'success',
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

end
