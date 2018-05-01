class PathsController < ApplicationController

  def show
    path = Path.find_by(shipper_id: params[:id])
    render json: {
        message: 'success',
        data: {
          path: path.path
        }
    }, status: :ok
  end

end
