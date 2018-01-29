require 'benchmark/ips'

# require_relative 'astar'

# q = AstarModule::Astar.new
include Astar

Benchmark.ips do |x|
  x.report("k=1") { AstarClass.find_path(2580820540,2579658115,1) }
  x.report("k=2")  { AstarClass.find_path(2580820540,2579658115,2)  }

  x.compare!
end
