require 'pry'
require 'pp'
require 'priority_queue'
require 'node'

module Astar
  class AstarClass
    def self.find_path(start_position, destination_position, k, heuristic_method)
      # Init
      start_edge = Way.find(road_matching(start_position))
      destination_edge = Way.find(road_matching(destination_position))

      @destination_node_1 = Node.new(destination_edge["source"], nil, 0, 0)
      @destination_node_2 = Node.new(destination_edge["target"], nil, 0, 0)

      start_node_1_heuristic_cost = calculate_heuristic_cost(start_edge["source"],destination_edge, heuristic_method)
      start_node_2_heuristic_cost = calculate_heuristic_cost(start_edge["target"],destination_edge, heuristic_method)

      @start_node_1 = Node.new(start_edge["source"], nil, 0, start_node_1_heuristic_cost)
      @start_node_2 = Node.new(start_edge["target"], nil, 0, start_node_2_heuristic_cost)

      open_list = PriorityQueue.new
      closed_list = Array.new
      current_arr = Array.new
      path = Array.new
      flag = 0

      open_list.push(@start_node_1)
      open_list.push(@start_node_2)

      while open_list.any? == true && flag == 0 do

        if open_list.get_size < k
          n = open_list.get_size
        else
          n = k
        end

        for i in 0...n
          current_arr[i] = open_list.pop
        end

        current_arr.each do |current_node|
          if current_node.id == @destination_node_1.id || current_node.id == @destination_node_2.id
            closed_list << current_node
            flag = 1

            # p "DESTINATION REACH!!!!!"
            return reconstruct(current_node.id, closed_list, path)
            # p "Cost in meters: #{current_node.cost}"
            break
          end
          get_adj(current_node.id).each do |adj_id|
            # Adj_cost = Real cost from start to parent + Distance between parent and adj + Heuristic from adj to destination
            #          = (Parent's cost - Heuristic from parent to destination) + Distance between parent and adj + Heuristic from adj to destination
            # adj_cost = get_distance(current_node.id, adj_id) + current_node.cost - calculate_heuristic_cost(current_node.id,destination_edge) + calculate_heuristic_cost(adj_id,destination_edge)

            # @adj_node = Node.new(adj_id,current_node.id, adj_cost)
            adj_real_cost = get_distance(current_node.id, adj_id) + current_node.real_cost
            adj_heuristic_cost = calculate_heuristic_cost(current_node.id,destination_edge, heuristic_method)

            @adj_node = Node.new(adj_id, current_node.id, adj_real_cost, adj_heuristic_cost)

            if open_list.compact.map(&:id).include? adj_id
              if @adj_node >= open_list.find(adj_id)
                next
              end
            elsif closed_list.compact.map(&:id).include? adj_id
              if @adj_node >= closed_list.compact.detect {|node| node.id == adj_id}
                next
                open_list.push(closed_list.compact.detect {|node| node.id == adj_id})
                closed_list.compact.delete_if{|node| node.id == adj_id}
              end
            else
              open_list.push(@adj_node)
            end
          end
          closed_list << current_node
        end
      end
    end

    # Find the nearest way base on location's osm_id
    def self.road_matching(current_osm_id)
      sql = "select w.gid, w.source, w.target, p.osm_id current_osm_id, st_distance (st_transform(p.way,2093), st_transform(w.the_geom,2093))
           from planet_osm_point p, ways w
           where p.osm_id = #{current_osm_id}
           order by st_distance (st_transform(p.way,2093), st_transform(w.the_geom,2093)) asc
           limit 1
          "
      result = ActiveRecord::Base.connection.execute(sql)
      result[0]["gid"]
    end

    # Calculate heuristic cost from a node_id (column id in ways table) to destination_edge (destination_id_1 or destination_id_2)
    # Result = the smaller cost
    def self.calculate_heuristic_cost(current_id, destination_edge_id, heuristic_method)
      destination_id_1 = Way.where(gid: destination_edge_id).first.source
      destination_id_2 = Way.where(gid: destination_edge_id).first.target

      destination_id_1_lat = Vertice.where(id: destination_id_1).first.lat
      destination_id_1_lon = Vertice.where(id: destination_id_1).first.lon
      destination_id_2_lat = Vertice.where(id: destination_id_2).first.lat
      destination_id_2_lon = Vertice.where(id: destination_id_2).first.lon

      current_id_lat = Vertice.where(id: current_id).first.lat
      current_id_lon = Vertice.where(id: current_id).first.lon

      dLon = [(destination_id_1_lon - current_id_lon).abs, (destination_id_2_lon - current_id_lon).abs].min
      dLat = [(destination_id_1_lat - current_id_lat).abs, (destination_id_2_lat - current_id_lat).abs].min


      case heuristic_method
        when 0
          return 0
        when 1
          sql1 = "select st_distance(st_transform(a.the_geom,2093), st_transform(b.the_geom,2093)) heuristic_cost
           from ways_vertices_pgr a, ways_vertices_pgr b
           where a.id = #{current_id} AND b.id = #{destination_id_1}
          "
          result1 = ActiveRecord::Base.connection.execute(sql1)

          sql2 = "select st_distance(st_transform(a.the_geom,2093), st_transform(b.the_geom,2093)) heuristic_cost
           from ways_vertices_pgr a, ways_vertices_pgr b
           where a.id = #{current_id} AND b.id = #{destination_id_2}
          "
          result2 = ActiveRecord::Base.connection.execute(sql2)
          return result1[0]["heuristic_cost"] <= result2[0]["heuristic_cost"] ? result1[0]["heuristic_cost"] : result2[0]["heuristic_cost"]
        when 2
          cd1 = coordinate_distance(destination_id_1_lat, destination_id_1_lon, current_id_lat, current_id_lon)
          cd2 = coordinate_distance(destination_id_2_lat, destination_id_2_lon, current_id_lat, current_id_lon)
          return [cd1, cd2].min
      end
    end

    def self.coordinate_distance(lat1, lon1, lat2, lon2)
      dLat = (lat2 - lat1).abs * Math::PI / 180
      dLon = (lon2 - lon1).abs * Math::PI / 180
      a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      result = 6371000 * c
      result
    end


    # The distance between 2 nodes in meters (column length_m in ways table)
    def self.get_distance(parent_id, current_id)
      if Way.where(source: parent_id, target: current_id).first == nil
        Way.where(target: parent_id, source: current_id).first.length_m
      else
        Way.where(source: parent_id, target: current_id).first.length_m
      end
    end

    # Get an array of current_node's adjacent nodes
    def self.get_adj(current_id)
      # Way.where(source: current_id, cost: 0..Float::INFINITY).map(&:target)
      sql1 = Way.where(source: current_id, cost: 0..Float::INFINITY).map(&:target)
      sql2 = Way.where(target: current_id, cost: 0..Float::INFINITY).map(&:source)
      sql1 + sql2
    end

    # Rebuild the path
    def self.reconstruct(node_id, closed_list, path)
      current_node = closed_list.detect {|node| node.id == node_id}
      if current_node.parent_id.nil?
        path.insert(0, current_node.id)
      end

      unless current_node.parent_id.nil?
        path.insert(0, node_id)
        reconstruct(current_node.parent_id, closed_list, path)
      end
      path
    end
  end
end




