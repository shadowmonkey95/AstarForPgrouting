require 'pry'
require 'pp'
require 'priority_queue'
require 'node'

module Matching
  class MatchingClass

    require 'algorithm/hungarian.rb'
    include Astar

    def self.match

      # costMatrix = [[12, 9, 27, 10, 23], [7, 13, 13, 30, 19], [25, 18, 26, 11, 26], [9, 28, 26, 23, 13], [16, 16, 24, 6, 9]]
      # hungarian = Hungarian.new
      # hungarian.setUpData(costMatrix)
      # hungarian.runMunkres
      # hungarian.show

      shop_id = 15
      shop = Shop.find_by_id(shop_id)
      shop_osm_id = findNearestPoint(shop.latitude.to_f, shop.longitude.to_f)

      shippers = findShipperArea(shop)
      distance = []
      shippers.each do |shipper|
        s = []
        s << shipper.id
        s << haversineAlgorithm(shop.latitude.to_f, shop.longitude.to_f, shipper.latitude.to_f, shipper.longtitude.to_f)
        distance << s
      end
      closest = distance.sort.first
      shipper_id = closest[0]
      shipper = Location.find_by_id(shipper_id)
      shipper_osm_id = findNearestPoint(shipper.latitude.to_f, shipper.longtitude.to_f)

      sql = "SELECT * FROM pgr_astar(
              'SELECT gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
            ARRAY[#{shipper_osm_id}], ARRAY[#{shop_osm_id}], heuristic :=4 )"

      path = ActiveRecord::Base.connection.execute(sql)
      # # k = []
      # # shop_osm_id.each do |l|
      # #   k << l
      # # end
      #
      # k
      # if shop_osm_id.present?
      #   return shop_osm_id
      # else
      #   return nil
      # end

      # invoice = Invoice.new
      # invoice.shop_id = shop_id
      # invoice.shipper_id = shipper_id
      #
      # if invoice.save
      #   status = 1
      # else
      #   status = 2
      # end

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

      def self.findPath(shipper_osm_id, shop_osm_id)

      end


      def self.haversineAlgorithm(lat1, lon1, lat2, lon2)
        dLat = (lat2 - lat1).abs * Math::PI / 180
        dLon = (lon2 - lon1).abs * Math::PI / 180
        a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
        result = 6371000 * c
        result
      end

      def self.hungarianAlgorithm

      end

  end
end

# requests = [
#   {
#     'latitude' => 21.016363,
#     'longitude' => 105.821304
#   },
#   {
#     'latitude' => 21.009563,
#     'longitude' => 105.834732
#   },
#   {
#     'latitude' => 20.965100,
#     'longitude' => 105.841849
#   },
#   {
#     'latitude' => 21.005897,
#     'longitude' => 105.843375
#   }
# ]
