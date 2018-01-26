require 'benchmark/ips'

require_relative 'astar'

q = Astar::Astar.new

Benchmark.ips do |x|
  x.report("k=1") { Astar::Astar.find_path(2580820540,2579658115,1) }
  x.report("k=2")  { Astar::Astar.find_path(2580820540,2579658115,2)  }

  x.compare!
end
