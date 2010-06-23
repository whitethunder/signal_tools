require 'signal_tools/array_extensions' #needed for sum, average
require 'signal_tools/common'
require 'signal_tools/macd'
require 'signal_tools/stochastic'
require 'signal_tools/ema'
require 'signal_tools/atr'
#require 'signal_tools/adx'
#require 'signal_tools/historical_data'
require 'yahoofinance'

module SignalTools
  Extra_Days     = 365
  @historical_data_cache, @macd_cache, @stochastic_cache, @ema_cache, @average_true_range_cache = {}, {}, {}, {}, {}
#  @open_prices, @high_prices, @low_prices, @close_prices, @volumes = [], [], [], [], []

  class << self

    def initialize(ticker, from_date, to_date)
      @historical_data = @historical_data_cache[cache_symbol([ticker, from_date, to_date])] ||= YahooFinance::get_historical_quotes(ticker, from_date-Extra_Days, to_date).reverse
    end

    def ema(ticker, from_date, to_date=Date.today, period=10)
      initialize(ticker, from_date, to_date)
      @ema_cache[cache_symbol(ticker, from_date, to_date, period)] ||= EMA.new(ticker, period, @historical_data)
    end

    def macd(ticker, from_date, to_date=Date.today, fast=8, slow=17, signal=9)
      initialize(ticker, from_date, to_date)
      @macd_cache[cache_symbol(ticker, from_date, to_date, fast, slow, signal)] ||= MACD.new(ticker, fast, slow, signal, @historical_data)
    end

    def stochastic(ticker, from_date, to_date=Date.today, k=14, d=5)
      initialize(ticker, from_date, to_date)
      @stochastic_cache[cache_symbol(ticker, from_date, to_date, k, d)] ||= Stochastic.new(ticker, k, d, @historical_data)
    end

    def average_true_range(ticker, from_date, to_date=Date.today, period=14)
      initialize(ticker, from_date, to_date)
      @average_true_range_cache[cache_symbol(ticker, from_date, to_date, period)] ||= ATR.new(ticker, period, @historical_data)
    end

#    def average_directional_index(ticker, from_date, to_date=Date.today, period=14)
#      initialize(ticker, from_date, to_date)
#      @average_directional_index_cache[cache_symbol(ticker, from_date, to_date, period)] ||= AverageDirectionalIndex.new(ticker, period, @historical_data)
#    end

    def cache_symbol(*args)
      args = args.map(&:to_s)
      args.join('_').to_sym
    end
  end
end
