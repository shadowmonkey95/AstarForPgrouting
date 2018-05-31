class PriorityQueueFake
  def initialize
    @elements = []
  end

  def <<(element)
    @elements << element
  end

  def pop
    @elements.sort!
    @elements.delete_at(0)
  end
end