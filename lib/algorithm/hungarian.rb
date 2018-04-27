class Hungarian

    def initialize
      @C = []
      @M = []
      @rowCover = []
      @colCover = []
      @C_orig = []
      @path = []
      @pathChild = []
      @nrow = 0;
      @ncol = 0;
      @step = 1;
      @path_row_0 = 0;
      @path_col_0 = 0;
      @path_count = 0;
      @asgn = 0;
      @debug = false;
    end

    def show
      @M
    end

    def setUpData(costMatrix)
      iSize = costMatrix.count
      @nrow = iSize
      @ncol = iSize
      @C = costMatrix
      @M = Array.new(iSize){Array.new(iSize, 0)}
      @rowCover = Array.new(iSize, 0)
      @colCover = Array.new(iSize, 0)
      @C_orig = []
      @path = []
      @step = 1
      @path_row_0 = 0
      @path_col_0 = 0
      @path_count = 0
      @asgn = 0
    end

    def runMunkres
      done = false
      while !done do
        case @step
        when 1
          step_one
        when 2
          step_two
        when 3
          step_three
        when 4
          step_four
        when 5
          step_five
        when 6
          step_six
        when 7
          step_seven
          done = true
        end
      end
    end

    private

      def step_one
        min_in_row = 10000
        (0..@nrow - 1).each do |r|
          min_in_row = @C[r][0]
          (0..@ncol - 1).each do |c|
            if @C[r][c] < min_in_row
              min_in_row = @C[r][c]
            end
          end
          (0..@ncol - 1).each do |c|
            @C[r][c] -= min_in_row
          end
        end
        @step = 2
      end

      def step_two
        (0..@nrow - 1).each do |r|
          (0..@ncol - 1).each do |c|
            if @C[r][c] == 0 && @rowCover[r] == 0 && @colCover[c] == 0
              @M[r][c] = 1
              @rowCover[r] = 1
              @colCover[c] = 1
            end
          end
        end
        (0..@nrow - 1).each do |r|
          @rowCover[r] = 0
        end
        (0..@ncol - 1).each do |c|
          @colCover[c] = 0
        end
        @step = 3
      end

      def step_three
        byebug
        colCount = 0
        (0..@nrow - 1).each do |r|
          (0..@ncol - 1).each do |c|
            if @M[r][c] == 1
              @colCover[c] = 1
            end
          end
        end
        (0..@ncol - 1).each do |c|
          if @colCover[c] == 1
            colCount += 1
          end
        end
        if colCount >= @ncol || colCount >= @nrow
          @step = 7
        else
          @step = 4
        end
      end

      def find_a_zero(coordinates)
        r = 0;
        c = 0;
        done = false;
        coordinates[0] = -1;
        coordinates[1] = -1;
        while !done do
          c = 0
          while true do
            if @C[r][c] == 0 && @rowCover[r] == 0 && @colCover[c] == 0
              coordinates[0] = r
              coordinates[1] = c
              done = true
            end
            c += 1
            break if c >= @ncol || done
          end
          r += 1
          if r >= @nrow
            done = true
          end
        end
        coordinates
      end

      def star_in_row(row)
        tmp = false;
        (0.. @ncol - 1).each do |c|
          if @M[row][c] == 1
            tmp = true
          end
        end
        tmp
      end

      def find_star_in_row(row)
        col = -1;
        (0..@ncol - 1).each do |c|
          if @M[row][c] == 1
            col = c
          end
        end
        col
      end

      def step_four
        byebug
        row = -1
        col = -1
        done = false
        coordinates = []
        coordinates << row
        coordinates << col
        while !done do
          coordinates = find_a_zero(coordinates)
          if coordinates[0] == -1
            done = true
            @step = 6
          else
            @M[coordinates[0]][coordinates[1]] = 2
            if star_in_row(coordinates[0])
              coordinates[1] = find_star_in_row(coordinates[0])
              @rowCover[coordinates[0]] = 1
              @colCover[coordinates[1]] = 0
            else
              done = true
              @step = 5
              @path_row_0 = coordinates[0]
              @path_col_0 = coordinates[1]
            end
          end
        end
      end

      def find_star_in_col(col)
        r = -1;
        (0..@nrow - 1).each do |i|
          if @M[i][col] == 1
            r = i
          end
        end
        r
      end

      def find_prime_in_row(r)
        c = -1;
        (0.. @ncol - 1).each do |i|
          if @M[r][i] == 2
            c = i
          end
        end
        c
      end

      def augment_path
        (0..@path_count - 1).each do |i|
          if @M[@path[i][0]][@path[i][1]] == 1
            @M[@path[i][0]][@path[i][1]] = 0
          else
            @M[@path[i][0]][@path[i][1]] = 1
          end
        end
      end

      def clear_covers
        (0.. @nrow - 1).each do |r|
          @rowCover[r] = 0
        end
        (0.. @ncol - 1).each do |c|
          @colCover[c] = 0
        end
      end

      def erase_primes
        (0.. @nrow - 1).each do |r|
          (0.. @ncol - 1).each do |c|
            if @M[r][c] == 2
              @M[r][c] = 0
            end
          end
        end
      end

      def step_five
        byebug
        done = false
        r = -1
        c = -1
        @path_count = 1
        @pathChild = []
        @pathChild << @path_row_0
        @pathChild << @path_col_0
        @path << @pathChild
        while !done do
          r = find_star_in_col(@path[@path_count - 1][1])
          if r > -1
            @path_count += 1
            @pathChild = []
            @pathChild << r
            @pathChild << @path[@path_count - 2][1]
            @path << @pathChild
          else
            done = true
          end
          if done
            c = find_prime_in_row(@path[@path_count - 1][0])
            @path_count += 1
            @pathChild = []
            @pathChild << @path[@path_count - 2][0]
            @pathChild << c
            @path << @pathChild
          end
        end
        augment_path
        clear_covers
        erase_primes
        @step = 3
      end

      def find_smallest(minval)
        (0.. @nrow - 1).each do |r|
          (0.. @ncol - 1).each do |c|
            if @rowCover[r] == 0 && @colCover[c] == 0
              if minval > @C[r][c]
                minval = @C[r][c]
              end
            end
          end
        end
        minval
      end

      def step_six
        byebug
        minval = 1000000
        minval = find_smallest(minval)
        (0.. @nrow - 1).each do |r|
          (0.. @ncol - 1).each do |c|
            if @rowCover[r] == 1
              @C[r][c] += minval
            end
            if @colCover[c] == 0
              @C[r][c] -= minval
            end
          end
        end
        @step = 4
      end

      def step_seven

      end

end
