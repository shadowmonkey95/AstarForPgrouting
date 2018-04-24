require 'pry'
require 'pp'
require 'priority_queue'
require 'node'

module Astar
  class AstarClass
    def self.find_path(start_position, destination_position, k, heuristic_method)
      # Init
      # Load tập các đỉnh vertices vào biến load_ver
      vertices = load_ver

      # Gán start_position, destination_position vào 2 đoạn đường gần
      start_edge = Way.find(road_matching(start_position))
      destination_edge = Way.find(road_matching(destination_position))

      # Khởi tạo 2 destination_node
      @destination_node_1 = Node.new(destination_edge["source"], nil, 0, 0)
      @destination_node_2 = Node.new(destination_edge["target"], nil, 0, 0)

      # Tính heuristic_cost cho 2 start_node
      start_node_1_heuristic_cost = calculate_heuristic_cost(start_edge["source"],destination_edge["source"], destination_edge["target"], heuristic_method, vertices)
      start_node_2_heuristic_cost = calculate_heuristic_cost(start_edge["target"],destination_edge["source"], destination_edge["target"], heuristic_method, vertices)

      # Khởi tạo 2 start_node
      @start_node_1 = Node.new(start_edge["source"], nil, 0, start_node_1_heuristic_cost)
      @start_node_2 = Node.new(start_edge["target"], nil, 0, start_node_2_heuristic_cost)

      # Khởi tạo open_list là 1 priority_queue, closed_list là 1 array
      open_list = PriorityQueue.new
      closed_list = Array.new
      current_arr = Array.new
      path = Array.new
      result = Array.new
      flag = 0

      # Push 2 start_node vào open_list
      open_list.push(@start_node_1)
      open_list.push(@start_node_2)

      # load_adj = các node lân cận vào 1 mảng các hash
      load_adj = load_adj(105.8529442,21.0314522,300000)

      while open_list.any? == true && flag == 0 do #Khi open_list vẫn còn phần tử hoặc vẫn chưa đến đích (flag == 0)
        if open_list.get_size < k # Check số phần tử trong mảng trước khi pop tránh trường hợp pop nhiều hơn số phần tử trong mảng => lỗi
          n = open_list.get_size
        else
          n = k
        end

        for i in 0...n
          current_arr[i] = open_list.pop #Pop k phần tử từ open_list rồi lưu vào 1 mảng để xử lý (mảng current_arr)
        end

        current_arr.each do |current_node| # Chạy vòng for cho các phần tử trong mảng current_arr
          # Thuật toán dừng khi đến đích
          if current_node.id == @destination_node_1.id || current_node.id == @destination_node_2.id
            closed_list << current_node
            flag = 1
            # return reconstruct(current_node.id, closed_list, path)
            path = reconstruct(current_node.id, closed_list, path)
            path.each do |node|
              tmp = []
              tmp << Vertice.find(node).lat.to_s
              tmp << Vertice.find(node).lon.to_s
              result.push(tmp)
            end
            return result
            break
          end

          # Nếu chưa đến đích tiếp tục tìm các node lân cận adj_node
          get_adj(current_node.id,load_adj).each do |adj_id|
            adj_real_cost = get_distance(current_node.id, adj_id, load_adj)+ current_node.real_cost
            adj_heuristic_cost = calculate_heuristic_cost(current_node.id,destination_edge["source"], destination_edge["target"], heuristic_method, vertices)

            @adj_node = Node.new(adj_id, current_node.id, adj_real_cost, adj_heuristic_cost)

            if open_list.compact.map(&:id).include? adj_id
              # Nếu đã có 1 node trong open_list có cùng id với adj_node  có cost thấp hơn thì ta continue (tiếp tục tìm tiếp)
              if @adj_node >= open_list.find(adj_id)
                next
              end
            elsif closed_list.compact.map(&:id).include? adj_id
              # Nếu đã có 1 node trong closed_list có cùng id với adj_node có cost thấp hơn thì ta continue (tiếp tục tìm tiếp)
              if @adj_node >= closed_list.compact.detect {|node| node.id == adj_id}
                next
                open_list.push(closed_list.compact.detect {|node| node.id == adj_id})
                closed_list.compact.delete_if{|node| node.id == adj_id}
              end
            else
              # Nếu không phải 2 trường hợp trên nghĩa là đã tìm thấy node tốt hơn hoặc chưa được duyệt ==> push vào open list để duyệt
              open_list.push(@adj_node)
            end
          end
          # Sau khi đã duyệt hết các node lân cận của current_node thì ta add current_node vào mảng closed_list để duyệt tiếp
          closed_list << current_node
        end
      end
    end

    def self.get_adj(current_id, load_adj)
      adjs1 = load_adj.select{|key| key["source"] == current_id}.map{|x| x["target"]}
      adjs2 = load_adj.select{|key| key["target"] == current_id && key["one_way"] !=1}.map{|x| x["source"]}
      adjs1 | adjs2
    end

    def self.get_distance(parent_id, current_id, load_adj)
      if load_adj.select{|x| x["target"] == parent_id && x["source"] == current_id}.map{|x| x["length_m"]}.first == nil
        load_adj.select{|x| x["source"] == parent_id && x["target"] == current_id}.map{|x| x["length_m"]}.first
      else
        load_adj.select{|x| x["target"] == parent_id && x["source"] == current_id}.map{|x| x["length_m"]}.first
      end
    end

    def self.calculate_heuristic_cost(current_id, destination_id_1, destination_id_2, heuristic_method, vertices)
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
          destination_id_1_lat = vertices.select{|key| key["id"] == destination_id_1}.map{|x| x["lat"]}.first.to_f
          destination_id_1_lon = vertices.select{|key| key["id"] == destination_id_1}.map{|x| x["lon"]}.first.to_f
          destination_id_2_lat = vertices.select{|key| key["id"] == destination_id_2}.map{|x| x["lat"]}.first.to_f
          destination_id_2_lon = vertices.select{|key| key["id"] == destination_id_2}.map{|x| x["lon"]}.first.to_f

          current_id_lat = vertices.select{|key| key["id"] == current_id}.map{|x| x["lat"]}.first.to_f
          current_id_lon = vertices.select{|key| key["id"] == current_id}.map{|x| x["lon"]}.first.to_f

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

    def self.load_adj(lon, lat, radius_in_meter)
      sql = "SELECT source, target, length_m, one_way
             FROM ways w
             WHERE ST_DWithin(the_geom, ST_MakePoint(#{lon},#{lat})::geography, #{radius_in_meter});
            "
      r = ActiveRecord::Base.connection.execute(sql)
      load_adj = []
      for i in 0...r.ntuples
        load_adj << r.[](i)
      end
      load_adj
    end

    def self.load_ver
      sql = "SELECT id, lon, lat FROM ways_vertices_pgr"
      r = ActiveRecord::Base.connection.execute(sql)
      load_ver = []
      for i in 0...r.ntuples
        load_ver << r.[](i)
      end
      load_ver
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
  class AstarDb
    def self.find_path(start_position, destination_position, heuristic_method)
      start_edge = Way.find(road_matching(start_position))
      destination_edge = Way.find(road_matching(destination_position))

      start_node_1 = start_edge["source"]
      start_node_2 = start_edge["target"]

      destination_node_1 = destination_edge["source"]
      destination_node_2 = destination_edge["target"]

      sql = "select * from pgr_astar(
            'select gid as id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM ways',
            ARRAY[#{start_node_1}, #{start_node_2}], ARRAY[#{destination_node_1}, #{destination_node_2}], heuristic := #{heuristic_method} )
            "
      result = ActiveRecord::Base.connection.execute(sql)
      edge_path = []
      for i in 0...result.ntuples
        edge_path << result.[](i)
      end

      total = 0
      edge_path.map{|x| x["edge"]}.each do |row|
        if row == -1
          p total
          return
        else
          print "#{row}"
          length_m = Way.where(gid: row).map(&:length_m).first
          total += length_m
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
  end
end
