class PathsController < ApplicationController

  def show
    path = Path.find_by(shipper_id: params[:id])
    if path
      render json: {
          message: 'success',
          data: {
            path: path.path
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

end
