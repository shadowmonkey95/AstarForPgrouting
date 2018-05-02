class ShippersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @shippers = Shipper.order('id ASC').paginate(:page => params[:page], :per_page => 10)

    fcm = FCM.new("AAAAy3ELMug:APA91bG8px-2Hoe7fALIS8KTJWqNMvkUnIZxNRAqeudKXkIxkGZqQryNa6RceGAx7mL0-U1xJrOLLO-P9lZjsZXZLiFajA8dwuxYS1QKZVGap7pxrnBZym2sbv5PdgZb2B68iJ_OBNXv")
    registration_ids = ['e_X_xBOyKEE:APA91bGM3eKU8tQYaXdSCoFqDiBUtqscxUJCut71vfdSWCB0ZEZfL48f3Qe7-I9uXQoBka-XjwiyorxhG7REVSPUW6w__R4-qaMUYtxqq4hOtCzCKZuyAKISRZYQBUQXEn61zf-g2I7T']
    options = {
        data: {
            data: {
                invoice_id: 1
            }
        }

    }
    fcm.send(registration_ids, options)
  end

  def destroy
    @shipper = Shipper.find_by_id(params[:id])
    @shipper.destroy
    redirect_to shippers_path
  end

  def register
    pars = params.require(:shipper).permit(:first_name, :second_name, :email, :password, :req_id)
    email = pars[:email]
    shipper = Shipper.find_by(email: email)
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
