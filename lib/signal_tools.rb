require 'signal_tools/array_extensions' #needed for sum, average
require 'signal_tools/common'
require 'signal_tools/macd'
require 'signal_tools/stochastic'
require 'signal_tools/ema'
require 'signal_tools/historical_data'

module SignalTools
  #TODO: Determine signal strength
#  attr_accessor :date_prices, :high_prices, :low_prices, :close_prices, :period, :ticker, :macd_divergence_points, :fast_stochastic
  attr_accessor :historical_data_cache, :macd_cache, :high_prices, :low_prices, :close_prices, :historical_data
  @historical_data_cache, @macd_cache, @stochastic_cache, @ema_cache = {}, {}, {}, {}
  @high_prices, @low_prices, @close_prices = [], [], []

  class << self
    Extra_Days = 60

    def initialize(ticker, days)
      @historical_data = @historical_data_cache[cache_symbol([ticker, days + Extra_Days])] ||= HistoricalData.new(ticker, days + Extra_Days)
    end

    def macd(ticker, period = 90, fast = 17, slow = 8, signal = 9)
      initialize(ticker, period)
      @macd_cache[cache_symbol(ticker, period, fast, slow, signal)] ||= MACD.new(fast, slow, signal, @historical_data)
    end

    def stochastic(ticker, period = 90, fast = 14, slow = 5)
      initialize(ticker, period)
      @stochastic_cache[cache_symbol(ticker, period, fast, slow)] ||= Stochastic.new(fast, slow, @historical_data)
    end

    def ema(ticker, period = 90, days = 10)
      initialize(ticker, period)
      @ema_cache[cache_symbol(ticker, period, days)] ||= EMA.new(days, @historical_data)
    end

    def get_signals(ticker, period = 90)
      m = macd(ticker, period)
      s = stochastic(ticker, period)
      e = ema(ticker, period)
      if m.macd_divergence_points[:divergence_points].last > 0.0
        puts "BUY"
      end
    end

    def cache_symbol(*args)
      args.map(&:to_s)
      args.join('_').to_sym
    end
  end
end
