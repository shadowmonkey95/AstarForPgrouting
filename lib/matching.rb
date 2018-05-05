require 'pry'
require 'pp'
require 'priority_queue'
require 'node'

module Matching
  class MatchingClass

    require 'algorithm/hungarian.rb'
    include Astar

    def self.match(request_id)
      # request = Request.find_by_id(request_id)
      # deposit = request.deposit

      # shop_id = request.shop_id
      shop = Shop.find_by_id(17)
      shop_vertice_id = findNearestPoint(shop.latitude.to_f, shop.longitude.to_f)

      locations = findShipperArea(shop)
      distance = []
      shipper_ids = ""
      if locations
        locations.each do |location|
          s = []
          s << haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, location.latitude.to_f, location.longtitude.to_f)
          s << location.shipper_id
          distance << s
        end
        distance = distance.sort_by{ |d| [d[0], d[1]] }
        shipper_id = distance.first[1]

        # location = Location.find_by(shipper_id: shipper_id)
        # location_vertice_id = findNearestPoint(location.latitude.to_f, location.longtitude.to_f)
        #
        # shipper = Shipper.find_by_id(shipper_id)
        # shipping_cost = shippingCost(distance.first[0])
        #
        # sql = "Select * from pgr_astar('SELECT gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
        #       ARRAY[#{location_vertice_id}], ARRAY[#{shop_vertice_id}], heuristic :=4 )"
        # result = ActiveRecord::Base.connection.execute(sql)
        #
        # node_result = Array.new
        # result.each do |result|
        #   node_result << result['node']
        # end
        #
        # path_result = Array.new
        # node_result.each do |node|
        #   tmp = Array.new
        #   tmp << Vertice.find(node).lat.to_s
        #   tmp << Vertice.find(node).lon.to_s
        #   path_result << tmp
        # end
        #
        # path = Path.new
        # path.shipper_id = shipper_id
        # path.path = path_result
        # path.save
        #
        # invoice = Invoice.new
        # invoice.shop_id = 17
        # invoice.shipper_id = shipper_id
        # invoice.distance = distance.first[0]
        # invoice.distance2 = distance.first[0]
        # invoice.shipping_cost = shipping_cost
        # invoice.deposit = 500000
        # invoice.user_id = shop.user_id
        # invoice.save
        # request.update_columns(status: "Found shipper")
        # if invoice.save
        #   invoice.create_activity key: 'invoice.create', recipient: User.where("id = #{invoice.user_id}").try(:first)
        # end

        (0..distance.count - 1).each do |i|
          shipper_ids += distance[i][1].to_s + ", "
        end
        available_shippers = Available.new
        available_shippers.invoice_id = 20
        available_shippers.shipper_id = shipper_ids
        available_shippers.save

        # sendNoti(shipper.req_id, invoice.id)
        # sendNoti(request_id, invoice_id)
      end
    end

    private

      def self.findShipperArea(shop)
        available_locations = []
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
            locations.each do |location|
              if location.shipper.status == "available"
                available_locations << location
              end
            end
            if available_locations.count > 0
              flag = 1
            else
              flag = 0
              k += 0.003
            end
          else
            k += 0.003
          end
          if k > 0.02
            flag = 1
          end
        end
        available_locations
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
