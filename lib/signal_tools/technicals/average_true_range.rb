require './lib/signal_tools/technicals/common'
require './lib/signal_tools/technicals/true_range'

module SignalTools::Technicals
  class AverageTrueRange
    include Common
    include TrueRange

    DEFAULT_PERIOD = 14

    attr_reader :period, :stock_data

    def initialize(stock_data, period)
      @period = period
      @stock_data = stock_data
    end

    def calculate
      average_true_ranges
    end

     # Takes a smoothing period and historical data and calculates the average
     # true ranges.
    def average_true_ranges
      trs = true_ranges(stock_data)
      atrs = [default_simple_average(trs.slice!(0...DEFAULT_PERIOD), DEFAULT_PERIOD)]
      trs.each { |tr| atrs << calculate_average_true_range(atrs.last, tr, period) }
      atrs
    end

    # Takes yesterday's average true range, today's true range, and the smoothing
    # period and calculates the day's average true range.
    def calculate_average_true_range(yesterday_atr, today_tr, period)
      (yesterday_atr * (period - 1) + today_tr) / period
    end

  end
end
