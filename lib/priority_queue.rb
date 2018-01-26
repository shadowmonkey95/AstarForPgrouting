module Astar
  class PriorityQueue
    def initialize
      @nodes = [nil]
    end

    def push(node)
      @nodes << node
      bubble_up(@nodes.size - 1)
    end

    def bubble_up(index)
      parent_index = (index / 2)

      # return if we reach the root node
      return if index <= 1

      # or if the parent is already smaller than the child
      return if @nodes[parent_index] <= @nodes[index]

      # otherwise we exchange the child with the parent
      exchange(index, parent_index)

      # and keep bubbling up
      bubble_up(parent_index)
    end

    def exchange(source, target)
      @nodes[source], @nodes[target] = @nodes[target], @nodes[source]
    end

    def pop
      # exchange the root with the last node
      exchange(1, @nodes.size - 1)

      # remove the last node of the list
      max = @nodes.pop

      # and make sure the tree is ordered again
      bubble_down(1)
      max
    end

    def bubble_down(index)
      child_index = (index * 2)

      # stop if we reach the bottom of the tree
      return if child_index > @nodes.size - 1

      # make sure we get the smallest child
      not_the_last_node = child_index < @nodes.size - 1
      left_node = @nodes[child_index]
      right_node = @nodes[child_index + 1]
      child_index += 1 if not_the_last_node && right_node < left_node

      # there is no need to continue if the parent node is already smaller
      # then its children
      return if @nodes[index] <= @nodes[child_index]

      exchange(index, child_index)

      # repeat the process until we reach a point where the parent
      # is larger than its children
      bubble_down(child_index)
    end

    def any?
      @nodes.any?
    end

    def get_size
      @nodes.size-1
    end

    def compact
      @nodes.compact(&:id)
    end

    def find(id)
      @nodes.compact.detect {|node| node.id == id}
    end

  end
end