require 'benchmark/ips'
require 'benchmark'
require 'element'
require 'priority_queue_fake'
require 'priority_queue'
class Bm
  include Astar
  def self.do(start, destination)
    case1 = PriorityQueueFake.new
    case2 = PriorityQueue.new

    # 15000.times do |i|
    #   case1 << Element.new("Foo #{i}", i)
    #   case2.push(Element.new("Foo #{i}", i))
    # end
    Benchmark.ips do |x|
      # x.report("k = 1, hc = 1") { AstarClass.find_path(2580820540,2579658115,1,1) }
      # x.report("k = 2, hc = 1")  { AstarClass.find_path(2580820540,2579658115,2,1)  }
      # x.report("k = 3, hc = 1")  { AstarClass.find_path(2580820540,2579658115,3,1)  }
      # x.report("k = 4, hc = 1")  { AstarClass.find_path(2580820540,2579658115,4,1)  }
      # x.report("k = 5, hc = 1")  { AstarClass.find_path(2580820540,2579658115,5,1)  }
      # x.report("k = 6, hc = 1")  { AstarClass.find_path(2580820540,2579658115,6,1)  }
      # x.report("k = 7, hc = 1")  { AstarClass.find_path(2580820540,2579658115,7,1)  }
      # x.report("k = 8, hc = 1")  { AstarClass.find_path(2580820540,2579658115,8,1)  }
      # x.report("k = 9, hc = 1")  { AstarClass.find_path(2580820540,2579658115,9,1)  }
      #
      # x.compare!

      # 0.055  (± 0.0%) i/s -      1.000  in  18.181195s
      #
      # Comparison:
      #     k = 1, hc = 1:        0.1 i/s
      # k = 2, hc = 1:        0.1 i/s - 1.11x  slower
      # k = 3, hc = 1:        0.1 i/s - 1.20x  slower
      # k = 4, hc = 1:        0.1 i/s - 1.30x  slower
      # k = 5, hc = 1:        0.1 i/s - 1.33x  slower
      # k = 6, hc = 1:        0.1 i/s - 1.50x  slower
      # k = 8, hc = 1:        0.1 i/s - 1.58x  slower
      # k = 7, hc = 1:        0.1 i/s - 1.62x  slower
      # k = 9, hc = 1:        0.1 i/s - 1.76x  slower

      # => #<Benchmark::IPS::Report:0x007f9ce08f37c8
      # @entries=
      # [#<Benchmark::IPS::Report::Entry:0x007f9cdfb5c218 @label="k = 1, hc = 1", @microseconds=10324902.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9cdfb5c290 @mean=0.09685321952692627, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9ce082a288 @label="k = 2, hc = 1", @microseconds=11409126.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9ce082a300 @mean=0.0876491328082449, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9cdc3dd210 @label="k = 3, hc = 1", @microseconds=12373202.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9cdc3dd2b0 @mean=0.08081982335696128, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9cdca8d830 @label="k = 4, hc = 1", @microseconds=13444757.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9cdca8d8a8 @mean=0.07437843614429031, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9ce096bbb0 @label="k = 5, hc = 1", @microseconds=13781476.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9ce096bc28 @mean=0.07256116833929833, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9cdc3be270 @label="k = 6, hc = 1", @microseconds=15530045.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9cdc3be338 @mean=0.06439131374055902, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9cdbe7b308 @label="k = 7, hc = 1", @microseconds=16749789.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9cdbe7b380 @mean=0.059702244607379835, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9cdf9e5830 @label="k = 8, hc = 1", @microseconds=16343001.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9cdf9e58a8 @mean=0.061188272582250965, @error=0>, @measurement_cycle=1, @show_total_time=true>,
      # #<Benchmark::IPS::Report::Entry:0x007f9cdf831c50 @label="k = 9, hc = 1", @microseconds=18181195.0, @iterations=1, @stats=#<Benchmark::IPS::Stats::SD:0x007f9cdf831d18 @mean=0.05500188518961487, @error=0>, @measurement_cycle=1, @show_total_time=true>], @data=nil>

      # x.report("AstarCustom") { AstarClass.find_path(start,destination,1,2) }
      # x.report("AstarDb") { AstarDb.find_path(start,destination,4) }
      # x.compare!

      # x.report("h0") { AstarDb.h0 }
      # x.report("h1") { AstarDb.h1 }
      # x.report("h2") { AstarDb.h2 }
      # x.report("h3") { AstarDb.h3 }
      # x.report("h4") { AstarDb.h4 }
      # x.report("h5") { AstarDb.h5 }

      # x.report("pgrAstar") { AstarDb.pgrAstar }
      # x.report("pgrbdAstar") { AstarDb.pgrbdAstar }
      # x.report("pgrDjstra") { AstarDb.pgrDjstra }
      # x.report("pgrbdDjstra") { AstarDb.pgrbdDjstra }
      # x.compare!

      # x.report("case1") { case1.pop }
      # x.report("case2")  { case2.pop  }
      x.report("case1 - Priority Queue with unordered array"){
        5000.times do |i|
          case1 << Element.new("Foo #{i}", i)
        end
        5000.times do
          case1.pop
        end
        # case1.pop
      }

      x.report("case2 - Priority Queue with binary heap"){
        5000.times do |i|
          case2.push(Element.new("Foo #{i}", i))
        end
        5000.times do
          case2.pop
        end
        # case2.pop
      }

      x.compare!

    end
  end

  # def self.bmtime
  #   case1 = PriorityQueueFake.new
  #   case2 = PriorityQueue.new
  #
  #   100000.times do |i|
  #     case1 << Element.new("Foo #{i}", i)
  #     case2.push(Element.new("Foo #{i}", i))
  #   end
  #   Benchmark.bmbm do |x|
  #     x.report("case1"){
  #       # 20000.times do |i|
  #       #   case1 << Element.new("Foo #{i}", i)
  #       # end
  #       1000.times do
  #         case1.pop
  #       end
  #
  #     }
  #     x.report("case2"){
  #       # 20000.times do |i|
  #       #   case2.push(Element.new("Foo #{i}", i))
  #       # end
  #       1000.times do
  #         case2.pop
  #       end
  #
  #     }
  #   end
  # end
end

