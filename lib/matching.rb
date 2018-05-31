require 'pry'
require 'pp'
require 'priority_queue'
require 'node'

module Matching
  class MatchingClass

    require 'algorithm/hungarian.rb'
    include Astar

    def self.matching_with_time
      # Thread.new do
      #   while true do
          time_now = (Time.now.to_f * 1000).to_i
          time_end = time_now + (60 * 60 * 1000)
          sec = (time_end.to_f / 1000).to_s
          date = Date.strptime(sec, '%s')
          requests = Request.where('reserve < ?', date)
          # thêm câu where check time = 0 ngay 1 sau 2 đã giao
          list = []
          delete = []
          if requests
            (0...requests.count).each do |k|
              shop = Shop.find_by_id(requests[k].shop_id)
              locations = findShipperArea(shop)
              distance = []
              if locations
                locations.each do |location|
                  s = []
                  s << haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, location.latitude.to_f, location.longtitude.to_f)
                  s << location.shipper_id
                  distance << s
                end
                distance = distance.sort_by{ |d| [d[0], d[1]] }
                count_list = list.count + 1
                distance.each do |i|
                  next if list.include? i[1]
                  list << i[1]
                  break if count_list == list.count
                end
              else
                delete << k
              end
            end
          end

          if delete
            delete.each do |del|
              requests.delete_at(del)
            end
          end

          cost_matrix = []
          requests.each do |request|
            cost_matrix_child = []
            list.each do |i|
              shop = Shop.find_by_id(request.shop_id)
              locate = Location.find_by(shipper_id: i)
              cost_matrix_child << haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, locate.latitude.to_f, locate.longtitude.to_f)
            end
            cost_matrix << cost_matrix_child
          end
          cost_matrix
          matched = Munkres.new(cost_matrix).find_pairings
          matched
          list
          # matched.each do |m|
          #   # sendNoti(Shipper.find_by_id(list[m[1]]).req_id, requests[m[0]].id, 0)
          # end
          # sleep 300
      #   end
      # end
    end

    def self.matching_now
      Thread.new do
        while true do
          queue = []
          new_queue = []
          File.open("requests.txt",'r') do |fileb|
            while line = fileb.gets
              queue << line
            end
          end
          while queue.count != 0
            new_queue.clear
            File.open("requests.txt",'r') do |fileb|
              while line = fileb.gets
                new_queue << line
              end
            end
            request = Request.find_by_id(queue.first.to_i)
            shop = Shop.find_by_id(request.shop_id)
            locations = findShipperArea(shop)
            distance = []
            if locations.count != 0
              locations.each do |location|
                s = []
                s << haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, location.latitude.to_f, location.longtitude.to_f)
                s << location.shipper_id
                distance << s
              end
              distance = distance.sort_by{ |d| [d[0], d[1]] }
              # sendNoti(Shipper.find_by_id(distance.first[1]).req_id, request.id, 0)
              File.open("shipper.txt",'w') do |filea|
                filea.puts "#{request.id}, #{distance.first[1]}"
              end
              set_available_shippers(distance, request.id)
              queue.delete_at(0)
              new_queue.delete_at(0)
            else
              flag = queue.first
              queue.delete_at(0)
              new_queue.delete_at(0)
              queue << flag
              new_queue << flag
            end

            difference = []
            difference = new_queue - queue
            if difference.empty? != true
              difference.each do |d|
                queue << d
              end
            end
            difference.clear

            File.open("requests.txt",'w') do |filea|
              queue.each do |q|
                filea.puts q
              end
            end

          end
          sleep 3
        end
      end

      # request_id = 23


      # request = Request.find_by_id(request_id)
      # deposit = request.deposit
      #
      # shop_id = request.shop_id
      # shop = Shop.find_by_id(shop_id)
      #
      # locations = findShipperArea(shop)
      # distance = []
      # if locations
      #   locations.each do |location|
      #     s = []
      #     s << haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, location.latitude.to_f, location.longtitude.to_f)
      #     s << location.shipper_id
      #     distance << s
      #   end
      #   distance = distance.sort_by{ |d| [d[0], d[1]] }
      #   shipper_id = distance.first[1]
      #
      #   shipper = Shipper.find_by_id(shipper_id)
      #   shipping_cost = shippingCost(distance.first[0])
      #
      #   invoice = Invoice.new
      #   invoice.shop_id = shop_id
      #   invoice.shipper_id = shipper_id
      #   invoice.distance = distance.first[0]
      #   invoice.distance2 = distance.first[0]
      #   invoice.shipping_cost = shipping_cost
      #   invoice.deposit = 500000
      #   invoice.user_id = shop.user_id
      #   invoice.save
      #   request.update_columns(status: "Found shipper")
      #   if invoice.save
      #     invoice.create_activity key: 'invoice.create', recipient: User.where("id = #{invoice.user_id}").try(:first)
      #   end
      #
        # set_available_shippers(distance)
      #   set_path(shop_id, shipper_id)
      #   sendNoti(shipper.req_id, invoice.id)
      # end
      # sendNoti("e_X_xBOyKEE:APA91bGM3eKU8tQYaXdSCoFqDiBUtqscxUJCut71vfdSWCB0ZEZfL48f3Qe7-I9uXQoBka-XjwiyorxhG7REVSPUW6w__R4-qaMUYtxqq4hOtCzCKZuyAKISRZYQBUQXEn61zf-g2I7T", 20, 0)

      # sendNoti("dKGI515zing:APA91bEAPx0QRdMv0r4aFoeUn4Ra-a7vLwTa3SAWM9eEX4hWHwH0huauDwtaBB1-mSkOQ2_pIgMBNAQBWrm4e9XuTUaHz7B1Icut0I5yNHlrWY9VQiMXNWpBSuYRw5L0TpHA6XcZG8eL", 1)
    end

    def self.set_path(shop_id, shipper_id)
      shop = Shop.find_by_id(shop_id)
      shop_vertice_id = findNearestPoint(shop.latitude.to_f, shop.longitude.to_f)

      location = Location.find_by(shipper_id: shipper_id)
      location_vertice_id = findNearestPoint(location.latitude.to_f, location.longtitude.to_f)

      sql = "Select * from pgr_astar('SELECT gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
            ARRAY[#{location_vertice_id}], ARRAY[#{shop_vertice_id}], heuristic :=4 )"
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

      path = Path.find_by(shipper_id: shipper_id)
      path.shipper_id = shipper_id
      path.path = path_result
      path.save
    end

    def self.shippingCost(distance)
      distance
    end

    def self.sendNoti(req_id, invoice_id, index)
      fcm = FCM.new("AAAAy3ELMug:APA91bG8px-2Hoe7fALIS8KTJWqNMvkUnIZxNRAqeudKXkIxkGZqQryNa6RceGAx7mL0-U1xJrOLLO-P9lZjsZXZLiFajA8dwuxYS1QKZVGap7pxrnBZym2sbv5PdgZb2B68iJ_OBNXv")
      registration_ids = [req_id]
      options = {
          data: {
              data: {
                  invoice_id: invoice_id,
                  index: index
              }
          }

      }
      fcm.send(registration_ids, options)
    end

    # private

      def self.findShipperArea(shop)
        available_locations = []
        shop_latitude = shop.latitude
        shop_longitude = shop.longitude
        k = 0.01
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
              k += 0.01
            end
          else
            k += 0.01
          end
          if k > 0.05
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
        # nearest_point = ActiveRecord::Base.connection.execute(sql)
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

      def self.set_available_shippers(distance, request_id)
        p 3
        shipper_ids = ""
        (0..distance.count - 1).each do |i|
          shipper_ids += distance[i][1].to_s + ", "
        end
        available_shippers = Available.new
        available_shippers.invoice_id = request_id
        available_shippers.shipper_id = shipper_ids
        available_shippers.index = 0
        available_shippers.save
      end

  end
end
