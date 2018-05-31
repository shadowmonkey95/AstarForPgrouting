class ShippersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @shippers = Shipper.order('id ASC').paginate(:page => params[:page], :per_page => 10)
  end

  def destroy
    @shipper = Shipper.find_by_id(params[:id])
    @shipper.destroy
    redirect_to shippers_path
  end

  def register
    pars = params.require(:shipper).permit(:first_name, :second_name, :email, :password, :req_id, :status)
    email = pars[:email]
    shipper = Shipper.find_by(email: email)
    if shipper
      render json: {
          message: 'error',
      }, status: :ok
    else
      shipper = Shipper.new(pars)
      shipper.save
      location = Location.new
      location.shipper_id = shipper.id
      location.latitude = 0
      location.longtitude = 0
      location.timestamp = 0
      location.save
      render json: {
          message: 'success',
          data: {
              shipper: shipper
          }
      }, status: :ok
    end
  end

  def login
    pars = params.require(:shipper).permit(:first_name, :second_name, :email, :password)
    email = pars[:email]
    password = pars[:password]
    shipper = Shipper.find_by_email(email)
    if shipper
      if shipper.password == password
        render json: {
            message: 'success',
            data: {
                shipper: shipper
            }
        }, status: :ok
      else
        render json: {
            message: 'error',
        }, status: :ok
      end
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def set_shipper_status
    id = params[:id]
    status = params[:status]
    shipper = Shipper.find_by_id(id)
    if shipper
      shipper.status = status
      shipper.save
      render json: {
        message: 'success',
      }, status: :ok
    else
      render json: {
        message: 'error',
      }, status: :ok
    end
  end

  def update_shipper
    pars = params.require(:shipper).permit(:id, :first_name, :second_name, :email)
    shipper = Shipper.find_by_id(pars['id'])
    if shipper
      shipper.first_name = pars['first_name']
      shipper.second_name = pars['second_name']
      shipper.email = pars['email']
      shipper.save
      render json: {
        message: 'success',
        data: {
          shipper: shipper
        }
      }, status: :ok
    else
      render json: {
        message: 'error',
      }, status: :ok
    end
  end

end
