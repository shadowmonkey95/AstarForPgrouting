module Astar
  class Node
    include Comparable

    attr_accessor :id, :parent_id, :real_cost, :heuristic_cost, :cost

    def initialize(id, parent_id=nil, real_cost=0, heuristic_cost=0)
      @id = id
      @parent_id = parent_id
      @real_cost = real_cost
      @heuristic_cost = heuristic_cost
      @cost = @real_cost + @heuristic_cost
    end

    def <=>(other)
      @cost <=> other.cost
    end

  end
end