require 'pry'
require 'pp'
require 'priority_queue'
require 'node'

module Matching
  class MatchingClass

    require 'algorithm/hungarian.rb'
    include Astar

    def self.match

      # point_id = ['2185', '14514', '3385', '14188', '6048', '14414', '11488', '1720', '4675', '3069', '17700', '11730', '7814', '16060', '640', '10049', '2326', '2621', '17986', '9902', '4221', '7411', '10558', '12526', '18039', '13095', '1651', '10726', '3657']
      # ways = []
      # (0..28).each do |i|
      #   sql = "
      #           select lat, lon from public.ways_vertices_pgr
      #           where id = #{point_id[i]}
      #         "
      #   path = ActiveRecord::Base.connection.execute(sql)
      #   point = []
      #   point << path[0]['lon']
      #   point << path[0]['lat']
      #   ways << point
      # end
      # ways

      (106..1066).each do |i|
        shipper = Shipper.find_by_id(i)
        shipper.id = shipper.id - 105
        shipper.save
      end


      # request_id = 19
      # request = Request.find_by_id(request_id)
      # deposit = request.deposit
      #
      # shop_id = request.shop_id
      # shop = Shop.find_by_id(shop_id)
      # shop_osm_id = findNearestPoint(shop.latitude.to_f, shop.longitude.to_f)
      #
      # locations = findShipperArea(shop)
      # distance = []
      # locations.each do |location|
      #   s = []
      #   s << haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, location.latitude.to_f, location.longtitude.to_f)
      #   s << location.shipper_id
      #   distance << s
      # end
      # distance = distance.sort_by{ |d| [d[0], d[1]] }
      # shipper_id = distance.first[1]
      #
      # location = Location.find_by(shipper_id: shipper_id)
      # location_osm_id = findNearestPoint(location.latitude.to_f, location.longtitude.to_f)
      #
      # shipper = Shipper.find_by_id(shipper_id)
      # shipping_cost = shippingCost(distance.first[0])
      #
      # path = Path.new
      # path.shipper_id = shipper_id
      # path.path = "[[21.00763660, 105.84384210], [21.00997620, 105.83587080], [21.00863450, 105.85098820], [21.01362710, 105.85242100], [21.00752810, 105.84183030], [21.00757410, 105.84149020], [21.00831750, 105.84839400], [21.01173370, 105.85168910], [21.00955460, 105.83517960], [21.00769480, 105.84070320], [21.00836830, 105.84867990], [21.00990890, 105.85156150], [21.00781900, 105.84022380], [21.00788790, 105.84579370], [21.00760460, 105.84121970], [21.00752020, 105.84269530], [21.00807820, 105.83893330], [21.00949230, 105.83526310], [21.00863140, 105.85146800], [21.00801950, 105.84681810], [21.00948020, 105.83755860], [21.01000750, 105.83591010], [21.01049530, 105.85160090], [21.00927490, 105.85151300], [21.01357430, 105.85178540], [21.00769890, 105.84432140], [21.00815010, 105.84748390], [21.00758610, 105.84135140], [21.01055440, 105.83661410]]"
      # path.save
      #
      # invoice = Invoice.new
      # invoice.shop_id = shop_id
      # invoice.shipper_id = shipper_id
      # invoice.distance = distance.first[0]
      # invoice.distance2 = distance.first[0]
      # invoice.shipping_cost = shipping_cost
      # invoice.deposit = deposit
      # invoice.user_id = shop.user_id
      # invoice.save
      # if invoice.save
      #   invoice.create_activity key: 'invoice.create', recipient: User.where("id = #{invoice.user_id}").try(:first)
      # end
      #
      # sendNoti(shipper.req_id, invoice.id)

    end

    private

      def self.findShipperArea(shop)
        shop_latitude = shop.latitude
        shop_longitude = shop.longitude
        k = 0.003
        flag = 0
        while flag == 0 do
          latitude_min = shop_latitude.to_f - k
          latitude_max = shop_latitude.to_f + k
          longitude_min = shop_longitude.to_f - k
          longitude_max = shop_longitude.to_f + k
          locations = Location.where('latitude < ?', latitude_max.to_s).where('latitude > ?', latitude_min.to_s).where('longtitude < ?', longitude_max.to_s).where('longtitude > ?', longitude_min.to_s)
          if locations.count > 0
            flag = 1
          else
            k += 0.003
          end
        end
        locations
      end

      def self.findNearestPoint(lat, lon)
        sql = "
                select id
                from public.ways_vertices_pgr
                order by the_geom <-> st_setsrid(st_makepoint(#{lon}, #{lat}),4326)
                limit 1
              "
        nearest_point = ActiveRecord::Base.connection.execute(sql)
        nearest_point[0]['id']
      end

      def self.haversineAlgorithm(lat1, lon1, lat2, lon2)
        dLat = (lat2 - lat1).abs * Math::PI / 180
        dLon = (lon2 - lon1).abs * Math::PI / 180
        a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
        result = 6371000 * c
        result
      end

      def self.shippingCost(distance)
        distance
      end

      def self.sendNoti(req_id, invoice_id)
        fcm = FCM.new("AAAAy3ELMug:APA91bG8px-2Hoe7fALIS8KTJWqNMvkUnIZxNRAqeudKXkIxkGZqQryNa6RceGAx7mL0-U1xJrOLLO-P9lZjsZXZLiFajA8dwuxYS1QKZVGap7pxrnBZym2sbv5PdgZb2B68iJ_OBNXv")
        registration_ids = [req_id]
        options = {
            data: {
                data: {
                    invoice_id: invoice_id
                }
            }

        }
        fcm.send(registration_ids, options)
      end

  end
end

# costMatrix = [[12, 9, 27, 10, 23], [7, 13, 13, 30, 19], [25, 18, 26, 11, 26], [9, 28, 26, 23, 13], [16, 16, 24, 6, 9]]
# hungarian = Hungarian.new
# hungarian.setUpData(costMatrix)
# hungarian.runMunkres
# hungarian.show

# sql = "SELECT * FROM pgr_astar(
#         'SELECT gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
#       ARRAY[#{shipper_osm_id}], ARRAY[#{shop_osm_id}], heuristic :=4 )"
#
# path = ActiveRecord::Base.connection.execute(sql)
# if shop_osm_id.present?
#   return shop_osm_id
# else
#   return nil
# end
# sql = "
#         select lat, lon from public.ways_vertices_pgr
#         where id in ('2185', '14514', '3385', '14188', '6048', '14414', '11488', '1720', '4675', '3069', '17700', '11730', '7814', '16060', '640', '10049', '2326', '2621', '17986', '9902', '4221', '7411', '10558', '12526', '18039', '13095', '1651', '10726', '3657')
#       "
# paths = ActiveRecord::Base.connection.execute(sql)
# roads = "["
# paths.each do |path|
#   roads += "[" + path['lat'] + ', ' + path['lon'] + "], "
# end
# roads = roads.chomp(', ')
# roads += ']'
