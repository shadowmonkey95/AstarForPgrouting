class AnothersController < ApplicationController

  include Matching

  skip_before_action :verify_authenticity_token

  def index
    fcm = FCM.new("AAAAy3ELMug:APA91bG8px-2Hoe7fALIS8KTJWqNMvkUnIZxNRAqeudKXkIxkGZqQryNa6RceGAx7mL0-U1xJrOLLO-P9lZjsZXZLiFajA8dwuxYS1QKZVGap7pxrnBZym2sbv5PdgZb2B68iJ_OBNXv")
    registration_ids = ["ebX-8EwPqoA:APA91bFVZ6V_iDPH_ZiYV9lsKc9GCP3kGbO9ARn7MlWbPw18Gk5PnNbmdKhNBz5_NjhYEhodv3XAnRkXaEkHDG0rRCquWwgjiMFS4Wton4WFH8NnMlUXMgsIVWOy-VOF2AGON_0gX6hQ"]
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
    request = Request.find_by_id(request_id)
    path = set_path(request.shop_id, shipper_id, request_id)
    shop = Shop.find_by_id(request.shop_id)
    location = Location.find_by(shipper_id: shipper_id)

    invoice = Invoice.new
    invoice.shop_id = shop.id
    invoice.shipper_id = shipper_id
    invoice.distance = haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, location.latitude.to_f, location.longtitude.to_f)
    # invoice.distance2 = distance.first[0]
    # invoice.shipping_cost = shipping_cost
    invoice.deposit = 100000
    invoice.user_id = shop.user_id
    invoice.request_id = request_id
    invoice.save
    request.update_columns(status: "Found shipper")

    render json: {
      message: 'success',
      data: {
        shipper_id: shipper_id,
        request_id: request_id,
        # path: '[["21.0288648", "105.7794524"], ["21.0286231", "105.7809988"], ["21.0282179", "105.7837082"], ["21.0281682", "105.7840558"], ["21.0281489", "105.7841906"], ["21.0279358", "105.7858096"], ["21.0277589", "105.7871848"], ["21.0279283", "105.7874132"], ["21.0291569", "105.7877118"], ["21.0303045", "105.787987"], ["21.0302767", "105.7881896"], ["21.0300617", "105.78963"], ["21.029769", "105.7911569"], ["21.029743", "105.7912545"], ["21.0295721", "105.7918946"], ["21.0299729", "105.7920371"], ["21.0305885", "105.7922674"], ["21.0309344", "105.7923857"], ["21.0316116", "105.7928338"], ["21.0319029", "105.7930265"], ["21.0323311", "105.7933081"], ["21.0347855", "105.7946319"], ["21.0345927", "105.7952285"], ["21.0347108", "105.7952656"], ["21.0347607", "105.7951266"], ["21.0355234", "105.7952035"], ["21.0356688", "105.7951518"], ["21.0358258", "105.7951027"]]'
        path: path
      }
    }, status: :ok
    # redirect_to root_path
  end

  # def self.accept_booking2(shipper_id, request_id)
  #
  #   request = Request.find_by_id(request_id)
  #   # path = set_path(request.shop_id, shipper_id)
  #   shop_id = 4
  #
  #   invoice = Invoice.new
  #   invoice.shop_id = shop_id
  #   invoice.shipper_id = shipper_id
  #   # invoice.distance = distance.first[0]
  #   # invoice.distance2 = distance.first[0]
  #   # invoice.shipping_cost = shipping_cost
  #   # invoice.deposit = 500000
  #   invoice.user_id = 5
  #   invoice.save
  #   request.update_columns(status: "Found shipper")
  #
  #   render json: {
  #       message: 'success',
  #       data: {
  #           shipper_id: shipper_id,
  #           request_id: request_id,
  #           # path: path
  #       }
  #   }, status: :ok
  # end

  def set_path(shop_id, shipper_id, request_id)
    shop = Shop.find_by_id(shop_id)
    shop_vertice_id = findNearestPoint(shop.latitude.to_f, shop.longitude.to_f)

    request = Request.find_by_id(request_id)
    destination_vertice_id = findNearestPoint(request.latitude.to_f, request.longitude.to_f)

    location = Location.find_by(shipper_id: shipper_id)
    location_vertice_id = findNearestPoint(location.latitude.to_f, location.longtitude.to_f)

    sql = "Select * from pgr_astar('SELECT gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
          ARRAY[#{location_vertice_id}], ARRAY[#{shop_vertice_id}], heuristic :=4)"
    result = ActiveRecord::Base.connection.execute(sql)

    sql2 = "Select * from pgr_astar('SELECT gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
          ARRAY[#{shop_vertice_id}], ARRAY[#{destination_vertice_id}], heuristic :=4 )"
    result2 = ActiveRecord::Base.connection.execute(sql2)

    node_result = Array.new
    result.each do |result|
      node_result << result['node']
    end

    node_result2 = Array.new
    result2.each do |result2|
      node_result2 << result2['node']
    end

    edge_result2 = Array.new
    result2.each do |result2|
      edge_result2 << result2['edge']
    end

    distance2 = 0
    time2 = 0
    result_array = Array.new
    edge_result2.each do |edge|
      if (edge == -1)
        result_array << distance2
        result_array << time2
        result_array
      else
        length_m = Way.find(edge).length_m
        distance2 += length_m
        cost_s = Way.find(edge).cost_s
        time2 += cost_s
      end
    end


    path_result = Array.new
    node_result.each do |node|
      tmp = Array.new
      tmp << Vertice.find(node).lat.to_s
      tmp << Vertice.find(node).lon.to_s
      path_result << tmp
    end

    path_result2 = Array.new
    node_result2.each do |node|
      tmp = Array.new
      tmp << Vertice.find(node).lat.to_s
      tmp << Vertice.find(node).lon.to_s
      path_result2 << tmp
    end



    path = Path.find_by(shipper_id: shipper_id)
    if path
      path.path = path_result
      path.path2 = path_result2
      path.distance2 = result_array[0]
      path.time2 = result_array[1]
      path.save
    else
      path = Path.new
      path.shipper_id = shipper_id
      path.path = path_result
      path.path2 = path_result2
      path.distance2 = result_array[0]
      path.time2 = result_array[1]
      path.save
    end

    path.path
  end

  def set_path2(request_id)
    request = Request.find_by_id(request_id)
    shop = Shop.find_by_id(request.shop_id)

    shop_vertice_id = findNearestPoint(shop.latitude.to_f, shop.longitude.to_f)
    destination_vertice_id = findNearestPoint(request.latitude.to_f, request.longtitude.to_f)

    sql = "Select * from pgr_astar('SELECT gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
          ARRAY[#{shop_vertice_id}], ARRAY[#{destination_vertice_id}], heuristic :=4 )"
    result = ActiveRecord::Base.connection.execute(sql)

    node_result = Array.new
    result.each do |result|
      node_result << result['node']
    end

    path_result = Array.new
    node_result.each do |node|
      tmp = Array.new
      tmp << Vertice.find(node).lat.to_s
      tmp << Vertice.find(node).lon.to_s
      path_result << tmp
    end

  end

  def findNearestPoint(lat, lon)
    sql = "
            select id
            from public.ways_vertices_pgr
            order by the_geom <-> st_setsrid(st_makepoint(#{lon}, #{lat}),4326)
            limit 1
          "
    nearest_point = ActiveRecord::Base.connection.execute(sql)
    nearest_point[0]['id']
  end

  def cancel_booking
    request_id = params[:request_id]
    index = params[:index]
    availables = Available.find_by(invoice_id: request_id)
    available = availables.shipper_id.split(', ')
    next_index = index.to_i + 1
    next_shipper = available[next_index]
    request = Request.find_by_id(request_id)
    shop = Shop.find_by_id(request.shop_id)
    if next_shipper
      fcm = FCM.new("AAAAy3ELMug:APA91bG8px-2Hoe7fALIS8KTJWqNMvkUnIZxNRAqeudKXkIxkGZqQryNa6RceGAx7mL0-U1xJrOLLO-P9lZjsZXZLiFajA8dwuxYS1QKZVGap7pxrnBZym2sbv5PdgZb2B68iJ_OBNXv")
      registration_ids = [Shipper.find_by_id(next_shipper).req_id]
      options = {
          data: {
              data: {
                  request_id: request_id,
                  address: shop.address,
                  index: next_index,
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
      File.open("requests.txt",'a+') do |filea|
        filea.puts request_id
      end
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

  def test
    pars = params[:id]
    render json: {
      message: 'success',
      data: {
        id: pars
      }
    }
  end

  def set_request_status
    request_id = params[:request_id]
    status = params[:status]
    request = Request.find_by_id(request_id)
    request.status = status
    if request.save
      render json: {
        message: 'success',
      }
    else
      render json: {
        message: 'error',
      }
    end
  end

  def haversineAlgorithm(lat1, lon1, lat2, lon2)
    dLat = (lat2 - lat1).abs * Math::PI / 180
    dLon = (lon2 - lon1).abs * Math::PI / 180
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    result = 6371000 * c
    result
  end

  def get_path_2
    shipper_id = params[:shipper_id]
    path = Path.find_by(shipper_id: shipper_id)
    if path
      render json: {
        message: 'success',
        data: {
          path: path
        }
      }
    else
      render json: {
        message: 'error',
      }
    end
  end

end
