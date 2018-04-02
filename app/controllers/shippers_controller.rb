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
          message: 'succcess',
          data: {
              shipper: shipper
          }
      }, status: :ok
    end

  end

end
