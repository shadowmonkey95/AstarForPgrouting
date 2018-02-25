require 'benchmark/ips'
class Bm
  include Astar
  def self.do(start, destination)
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

      x.report("AstarCustom") { AstarClass.find_path(start,destination,1,2) }
      x.report("AstarDb") { AstarDb.find_path(start,destination,4) }
      x.compare!

    end
  end
end

