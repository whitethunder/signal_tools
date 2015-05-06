require './lib/signal_tools/technicals/common'

module SignalTools
  class Stock
    include ::SignalTools::Technicals::Common

    DEFAULT_PERIOD = 90

    attr_accessor :ticker
    attr_reader :dates, :stock_data

    def initialize(ticker, from_date=Date.today-DEFAULT_PERIOD, to_date=Date.today)
      from_date = Date.parse(from_date) unless from_date.is_a?(Date)
      to_date = Date.parse(to_date) unless to_date.is_a?(Date)
      @ticker = ticker
      @stock_data = SignalTools::StockData.new(ticker, from_date, to_date)
      @dates = stock_data.dates
    end

    def ema(period=10, type=:default)
      ema_data = SignalTools::Technicals::EMA.new(stock_data.close_prices, period, type).calculate
      trim_data_to_range(ema_data, dates.size)
    end

    def macd(fast=8, slow=17, signal=9)
      macd_data = SignalTools::Technicals::MACD.new(stock_data.close_prices, fast, slow, signal).calculate
      trim_data_to_range(macd_data, dates.size)
    end

    def fast_stochastic(k_period=14, d_period=5)
      stochastic_data = SignalTools::Technicals::FastStochastic.new(stock_data, k_period, d_period).calculate
      trim_data_to_range(stochastic_data, dates.size)
    end

    def slow_stochastic(k_period=14, d_period=5)
      stochastic_data = SignalTools::Technicals::SlowStochastic.new(stock_data, k_period, d_period).calculate
      trim_data_to_range(stochastic_data, dates.size)
    end

    def average_true_range(period=14)
      atr_data = SignalTools::Technicals::AverageTrueRange.new(stock_data, period).calculate
      trim_data_to_range(atr_data, dates.size)
    end

    def average_directional_index(period=14)
      adx_data = SignalTools::Technicals::AverageDirectionalIndex.new(stock_data, period).calculate
      trim_data_to_range(adx_data, dates.size)
    end
  end
end
