module SignalTools
  class Stock
    Default_Period = 90
    EMA_Seed_Days = 10
    Slow_K_SMA = 3
    ATR_Seed_Days = 14

    attr_accessor :ticker
    attr_reader :stock_data

    def initialize(ticker, from_date=Date.today-Default_Period, to_date=Date.today)
      from_date = Date.parse(from_date) unless from_date.is_a?(Date)
      to_date = Date.parse(to_date) unless to_date.is_a?(Date)
      @ticker = ticker
      @stock_data = SignalTools::StockData.new(ticker, from_date, to_date)
    end

    def dates
      @stock_data.dates
    end

    # Takes a period of days over which to average closing prices and returns the exponential moving average for each day.
    def ema(period=10)
      trim_data_to_range(ema_points(period, @stock_data.close_prices))
    end

    def macd(fast=8, slow=17, signal=9)
      trim_data_to_range(macd_points(fast, slow, signal))
    end

    def fast_stochastic(k=14, d=5)
      trim_data_to_range(fast_stochastic_points(k, d))
    end

    def slow_stochastic(k=14, d=5)
      trim_data_to_range(slow_stochastic_points(k, d))
    end

    def atr(period=14)
      trim_data_to_range(average_true_ranges(period))
    end

    def adx(period=14)
      trim_data_to_range(average_directional_indexes(period))
    end

    private

    #### EMA methods

    def ema_points(period, data, type=:default)
      emas = [default_simple_average(data, EMA_Seed_Days)]
      if type == :wilder
        data.slice(EMA_Seed_Days..-1).each { |current| emas << calculate_wilder_ema(emas.last, current, period) }
      else
        data.slice(EMA_Seed_Days..-1).each { |current| emas << calculate_ema(emas.last, current, period) }
      end
      emas
    end

    #Takes current value, previous day's EMA, and number of days. Returns EMA for that day.
    def calculate_ema(previous, current, period)
      (current - previous) * (2.0 / (period + 1)) + previous
    end

    #Uses Wilder's moving average formula.
    def calculate_wilder_ema(previous, current, period)
      (previous * (period - 1) + current) / period
    end

    #Takes a period and array of data and calculates the sum ema over the period specified.
    def period_sum_ema(period, data)
      raise if data.size <= period
      sum_emas = [SignalTools.sum(data[0...period])]
      data[(period..-1)].each do |today|
        sum_emas << (sum_emas.last - (sum_emas.last / period) + today)
      end
      sum_emas
    end

    #### MACD Methods

    # Takes a period of days for fast, slow, signal, and time period (eg 8,17,9).
    def macd_points(fast, slow, signal)
      fast_ema_points = ema_points(fast, @stock_data.close_prices)
      slow_ema_points = ema_points(slow, @stock_data.close_prices)
      macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
    end

    def macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
      macds = differences_between_arrays(fast_ema_points, slow_ema_points)
      signal_points = ema_points(signal, macds)
      divergences = differences_between_arrays(macds, signal_points)
      {:signal_points => signal_points, :divergences => divergences}
    end

    # Returns an array with the differences between the first_points and second_points
    def differences_between_arrays(first_points, second_points)
      SignalTools.truncate_to_shortest!(first_points, second_points)
      differences = []
      first_points.each_with_index { |fp, index| differences << fp - second_points[index] }
      differences
    end

    #### Stochastic Methods

    def fast_stochastic_points(k_period, d_period)
      k_points = calculate_fast_stochastic_k_points(k_period)
      d_points = calculate_d_points(k_points, d_period)
      k_d_points(k_points, d_points)
    end

    def slow_stochastic_points(k_period, d_period)
      fast_points = fast_stochastic_points(k_period, d_period)
      k_points = slow_k_points(fast_points[:k])
      slow_d_points = calculate_d_points(k_points, d_period)
      k_d_points(k_points, slow_d_points)
    end

    def calculate_fast_stochastic_k_points(period)
      index = 0
      points = []
      while((index + period) <= @stock_data.close_prices.size)
        today_cp = @stock_data.close_prices[index + period - 1]
        low_price = get_for_period(@stock_data.low_prices, index, index + period - 1, :min)
        high_price = get_for_period(@stock_data.high_prices, index, index + period - 1, :max)
        points << (today_cp - low_price) / (high_price - low_price)
        index += 1
      end
      points
    end

    def calculate_d_points(k_points, period)
      collection_for_array(k_points, period, :average)
    end

    def k_d_points(k_points, d_points)
      raise unless k_points.size > d_points.size
      SignalTools.truncate_to_shortest!(k_points, d_points)
      {:k => k_points, :d => d_points}
    end

    def slow_k_points(fast_k_points)
      collection_for_array(fast_k_points, Slow_K_SMA, :average)
    end

    #### True Range Methods

     # Takes a smoothing period and historical data and calculates the average
     # true ranges.
    def average_true_ranges(period)
      trs = true_ranges
      atrs = [default_simple_average(trs.slice!(0...ATR_Seed_Days), ATR_Seed_Days)]
      trs.each { |tr| atrs << calculate_average_true_range(atrs.last, tr, period) }
      atrs
    end

    # Takes historical data and computes the true ranges.
    def true_ranges
      trs = [@stock_data.high_prices.first - @stock_data.low_prices.first]
      index = 1
      while index < (@stock_data.high_prices.size)
        trs << true_range(@stock_data.raw_data[index], @stock_data.raw_data[index-1])
        index += 1
      end
      trs
    end

    # Takes today's data and yesterday's data and computes the true range.
    def true_range(today, yesterday)
      [
        today[SignalTools::StockData::Indexes[:high]] - today[SignalTools::StockData::Indexes[:low]],
        (yesterday[SignalTools::StockData::Indexes[:close]] - today[SignalTools::StockData::Indexes[:high]]).abs,
        (yesterday[SignalTools::StockData::Indexes[:close]] - today[SignalTools::StockData::Indexes[:low]]).abs
      ].max
    end

    # Takes yesterday's average true range, today's true range, and the smoothing
    # period and calculates the day's average true range.
    def calculate_average_true_range(yesterday_atr, today_tr, period)
      (yesterday_atr * (period - 1) + today_tr) / period
    end

    #### Average Directional Index Methods

    def average_directional_indexes(period)
      dxs = directional_indexes(plus_directional_index(period), minus_directional_index(period))
      adxs = ema_points(period, dxs, :wilder)
      adxs
    end

    def directional_indexes(plus_dis, minus_dis)
      SignalTools.truncate_to_shortest!(plus_dis, minus_dis)
      differences, sums = [], []
      index = 0
      while index < plus_dis.size
        differences << (plus_dis[index] - minus_dis[index]).abs
        sums << (plus_dis[index] + minus_dis[index])
        index += 1
      end
      quotients(differences, sums)
    end

    def plus_directional_index(period)
      plus_dms = plus_directional_movement(@stock_data.raw_data)
      plus_dm_sums = period_sum_ema(period, plus_dms)
      true_range_sums = period_sum_ema(period, true_ranges)
      quotients(plus_dm_sums, true_range_sums)
    end

    def minus_directional_index(period)
      minus_dms = minus_directional_movement(@stock_data.raw_data)
      minus_dm_sums = period_sum_ema(period, minus_dms)
      true_range_sums = period_sum_ema(period, true_ranges)
      quotients(minus_dm_sums, true_range_sums)
    end

    def quotients(first, second)
      SignalTools.truncate_to_shortest!(first, second)
      index = 0
      quots = []
      while index < first.size
        quots << first[index] / second[index]
        index += 1
      end
      quots
    end

    def plus_directional_movement(data)
      plus_dm = []
      data.each_cons(2) do |two_days|
        um = up_move(two_days.last, two_days.first)
        dm = down_move(two_days.last, two_days.first)
        plus_dm << ((um > dm) ? um : 0)
      end
      plus_dm
    end

    def minus_directional_movement(data)
      minus_dm = []
      data.each_cons(2) do |two_days|
        um = up_move(two_days.last, two_days.first)
        dm = down_move(two_days.last, two_days.first)
        minus_dm << ((dm > um) ? dm : 0)
      end
      minus_dm
    end

#TODO: Pass in only the high prices to this method
    # Up move is today_high - yesterday_high
    def up_move(today, yesterday)
      diff = today[SignalTools::StockData::Indexes[:high]] - yesterday[SignalTools::StockData::Indexes[:high]]
      diff > 0 ? diff : 0
    end

#TODO: Pass in only the low prices to this method
    # Down move is yesterday_low - today_low
    def down_move(today, yesterday)
      diff = yesterday[SignalTools::StockData::Indexes[:low]] - today[SignalTools::StockData::Indexes[:low]]
      diff > 0 ? diff : 0
    end

    #### Misc Utility Methods

    # Returns only the points specific to the date range given.
    def trim_data_to_range(data)
      if data.is_a? Array
        data.slice!(0...(-dates.size))
      elsif data.is_a? Hash
        data.each { |k,v| v = v.slice!(0...(-dates.size)) }
      end
      data
    end

    # Gets the first 0...period of numbers from data and returns a simple average.
    def default_simple_average(data, period)
      SignalTools.average(data.slice(0...period))
    end

    #Runs method for the given slice of the array.
    def get_for_period(points, start, finish, method)
      case method
        when :average
          SignalTools.average(points.slice(start..finish))
        else
          (points.slice(start..finish)).send(method)
        end
    end

    #Returns a collection of values by iterating over an array, slicing it period
    # elements at a time and calling method for each slice.
    def collection_for_array(points, period, method)
      raise unless points.size >= period
      collection = []
      index = 0
      while((index + period - 1) < points.size)
        collection << get_for_period(points, index, (index + period - 1), method)
        index += 1
      end
      collection
    end

    def matching_dates(array)
      dates = @stock_data.dates.dup
      SignalTools.truncate_to_shortest!(dates, array)
      @dates = dates
    end
  end
end
