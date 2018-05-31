class AnothersController < ApplicationController

  include Matching

  skip_before_action :verify_authenticity_token

  def index
    fcm = FCM.new("AAAAy3ELMug:APA91bG8px-2Hoe7fALIS8KTJWqNMvkUnIZxNRAqeudKXkIxkGZqQryNa6RceGAx7mL0-U1xJrOLLO-P9lZjsZXZLiFajA8dwuxYS1QKZVGap7pxrnBZym2sbv5PdgZb2B68iJ_OBNXv")
    registration_ids = ["fYOFBG4bsoY:APA91bHk5SVq3Ek9b-m2rZ0LnBHqi8QWfATl0iWvSSKyaBq18eOjlo_iilKrTHN1ocB7aa2ytYFUdjTiaYTvl6HX6wHaPYq8c3TpVjhclhR9rBwwsENmetstUJjTWRkkd02YHmKQ8xRC"]
    options = {
        data: {
            data: {
                request_id: 265,
                address: "68 Hoàng Cầu Mới, Chợ Dừa, Đống Đa, Hà Nội, Việt Nam",
                index: 0,
            }
        }
    }
    # <%= @m.find_pairings %>
    response = fcm.send(registration_ids, options)
    # cost_matrix = [[12, 9, 27, 10, 23],
    #               [7, 13, 13, 30, 19],
    #               [25, 18, 26, 11, 26],
    #               [9, 28, 26, 23, 13],
    #               [16, 16, 24, 6, 9]]

    # $queue << 2

    # cost_matrix = [[90, 75, 75, 80],
    #               [35, 85, 55, 65],
    #               [125, 95, 90, 105],
    #               [45, 110, 95, 115]]
    #
    # @m = Munkres.new(cost_matrix)

    @distance = [[135.73303826374593, 752], [157.39694005714534, 198], [199.17735189763565, 438], [213.50262080555802, 445], [298.1252757251832, 114], [314.47770747188537, 74], [335.5402670969189, 602], [336.7162570805184, 483], [355.5590709511787, 222], [376.87221499460856, 753], [436.1024883693564, 412], [463.13220677844646, 243], [494.15564173664, 121], [505.9594953248391, 327], [529.2716964420458, 638], [533.4919916557055, 922], [547.4305764986428, 17], [547.6004810295757, 599], [611.4787516268128, 102], [648.0859640211511, 585], [716.828267597335, 576], [721.7068907093965, 627], [747.7843471100542, 504], [751.8495659312345, 737], [779.7677302448973, 5], [782.0341994979623, 273], [782.0341994979623, 344], [800.0516528682068, 59], [800.0516528682068, 878], [800.3148629030783, 819], [899.4803460666882, 200], [1060.4748987790601, 934], [1061.6777218076272, 587], [1193.144203653797, 919], [1195.1540189033187, 96], [1324.4921293627806, 287]]

    @test_hungary = Location.where('latitude <= ?', '21.023393').where('latitude >= ?', '21.003393').where('longtitude <= ?', '105.851317').where('longtitude >= ?', '105.831317')

  end

  def get_shop
    shop = Shop.find(params[:shop_id])
    if shop
      render json: {
          message: 'success',
          data: {
              shop: shop
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def get_invoices
    invoice_ids = params[:invoice_ids].split(', ')
    invoices = Invoice.where(:id => invoice_ids)
    if invoices
      shops = []
      invoices.each do |invoice|
        shop = Shop.find(invoice.shop_id)
        if shop
          shops << shop
        end
      end
      render json: {
          message: 'success',
          data: {
              invoices: invoices,
              shops: shops
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

  def set_invoice
    pars = params.require(:invoice).permit(:shop_id, :shipper_id, :distance, :distance2, :shipping_cost, :deposit, :user_id)
    invoice = Invoice.new(pars)
    if invoice.save
      render json: {
          message: 'success',
      }, status: :ok
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

  def accept_booking
    shipper_id = params[:shipper_id]
    request_id = params[:request_id]
    render json: {
      message: 'success',
      data: {
        shipper_id: shipper_id,
        request_id: request_id,
        path: "[[\"105.85242100\", \"21.01362710\"], [\"105.85178540\", \"21.01357430\"], [\"105.85168910\", \"21.01173370\"], [\"105.85160090\", \"21.01049530\"], [\"105.85156150\", \"21.00990890\"], [\"105.85151300\", \"21.00927490\"], [\"105.85146800\", \"21.00863140\"], [\"105.85098820\", \"21.00863450\"], [\"105.84867990\", \"21.00836830\"], [\"105.84839400\", \"21.00831750\"], [\"105.84748390\", \"21.00815010\"], [\"105.84681810\", \"21.00801950\"], [\"105.84579370\", \"21.00788790\"], [\"105.84432140\", \"21.00769890\"], [\"105.84384210\", \"21.00763660\"], [\"105.84269530\", \"21.00752020\"], [\"105.84183030\", \"21.00752810\"], [\"105.84149020\", \"21.00757410\"], [\"105.84135140\", \"21.00758610\"], [\"105.84121970\", \"21.00760460\"], [\"105.84070320\", \"21.00769480\"], [\"105.84022380\", \"21.00781900\"], [\"105.83893330\", \"21.00807820\"], [\"105.83755860\", \"21.00948020\"], [\"105.83661410\", \"21.01055440\"], [\"105.83591010\", \"21.01000750\"], [\"105.83587080\", \"21.00997620\"], [\"105.83526310\", \"21.00949230\"], [\"105.83517960\", \"21.00955460\"]]"
      }
    }, status: :ok
  end

  def cancel_booking
    invoice_id = params[:invoice_id]
    index = params[:index]
    availables = Available.find_by(invoice_id: invoice_id)
    available = availables.shipper_id.split(', ')
    next_index = index.to_i + 1
    next_shipper = available[next_index]
    if next_shipper
      fcm = FCM.new("AAAAy3ELMug:APA91bG8px-2Hoe7fALIS8KTJWqNMvkUnIZxNRAqeudKXkIxkGZqQryNa6RceGAx7mL0-U1xJrOLLO-P9lZjsZXZLiFajA8dwuxYS1QKZVGap7pxrnBZym2sbv5PdgZb2B68iJ_OBNXv")
      registration_ids = ["dGND3vAvUzE:APA91bEHd4BFQD5FQDC2q2ruady113betd9tr0yCrUHlP7ff1oQ0BueohXVsIWK3CPqk2ZK3EiTbJ0Op62cMjCEQW-PPHfvDHaA9nsGwBB3Faj0rz-13UE3oGDpomX9_aiSYEZ83u8Xb"]
      options = {
          data: {
              data: {
                  request_id: 265,
                  address: "68 Hoàng Cầu Mới, Chợ Dừa, Đống Đa, Hà Nội, Việt Nam",
                  index: 1,
              }
          }
      }
      response = fcm.send(registration_ids, options)
      render json: {
        message: 'success',
        data: {
          next_shipper: next_shipper
        }
      }, status: :ok
    else
    end
  end

  def create_shop
    pars = params.require(:shop).permit(:name, :address, :longitude, :latitude)
    shop = Shop.new(pars)
    if shop.save
      render json: {
          message: 'success',
          data: {
            shop: shop
          }
      }, status: :ok
    else
      render json: {
          message: 'error',
      }, status: :ok
    end
  end

end
