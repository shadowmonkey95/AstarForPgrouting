class WaysController < ApplicationController
  include Astar

  def find_path
    # @path = Astar.find_path(2580820540,2579658115,1)
  end

  def show
    # @path = Astar.find_path(2580820540,2579658115,1)
  end

  def index
    @path = AstarClass.find_path(2580820540,2579658115,1,1)
  end
end
