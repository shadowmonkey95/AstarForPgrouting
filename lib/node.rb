module Astar
  class Node
    include Comparable

    attr_accessor :id, :cost, :parent_id

    def initialize(id, parent_id=nil, cost=0)
      @id = id
      @parent_id = parent_id
      @cost = cost
    end

    def <=>(other)
      @cost <=> other.cost
    end

  end
end