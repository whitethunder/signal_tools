require './lib/signal_tools/technicals/true_range'

module SignalTools::Technicals
  class AverageDirectionalIndex
    include TrueRange

    attr_reader :period, :stock_data

    def initialize(stock_data, period)
      @stock_data = stock_data
      @period = period
    end

    def calculate
      # trim_data_to_range!(average_directional_indexes(period))
      average_directional_indexes
    end

    def average_directional_indexes
      dxs = directional_indexes(plus_directional_index, minus_directional_index)
      adxs = EMA.new(dxs, period, :wilder).calculate
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

    def plus_directional_index
      plus_dms = plus_directional_movement(@stock_data.raw_data)
      plus_dm_sums = period_sum_ema(plus_dms)
      true_range_sums = period_sum_ema(true_ranges(stock_data))
      quotients(plus_dm_sums, true_range_sums)
    end

    def minus_directional_index
      minus_dms = minus_directional_movement(@stock_data.raw_data)
      minus_dm_sums = period_sum_ema(minus_dms)
      true_range_sums = period_sum_ema(true_ranges(stock_data))
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

    #Takes a period and array of data and calculates the sum ema over the period specified.
    def period_sum_ema(data)
      raise if data.size <= period
      sum_emas = [SignalTools.sum(data[0...period])]
      data[(period..-1)].each do |today|
        sum_emas << (sum_emas.last - (sum_emas.last / period) + today)
      end
      sum_emas
    end
  end
end