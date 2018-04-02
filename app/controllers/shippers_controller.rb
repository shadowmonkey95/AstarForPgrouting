class ShippersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index

    @shippers = Shipper.all

  end

  def register

    pars = params.require(:shipper).permit(:first_name, :second_name, :email, :password)
    email = pars[:email]
    shipper = Shipper.find_by_email(email)
    if shipper
      render json: {
          message: 'error',
      }, status: :ok
    else
      shipper = Shipper.new(pars)
      shipper.save
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

end