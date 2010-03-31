require 'signal_tools/array_extensions' #needed for sum, average
require 'signal_tools/common'
require 'signal_tools/macd'
require 'signal_tools/stochastic'
require 'signal_tools/ema'
require 'signal_tools/historical_data'

module SignalTools
  #TODO: Determine signal strength
#  attr_accessor :historical_data_cache, :macd_cache, :stochastic_cache, :ema_cache, :high_prices, :low_prices, :close_prices, :historical_data
  Extra_Days = 60
  @historical_data_cache, @macd_cache, @stochastic_cache, @ema_cache = {}, {}, {}, {}
  @high_prices, @low_prices, @close_prices = [], [], []

  class << self

    def initialize(ticker, days)
      @historical_data = @historical_data_cache[cache_symbol([ticker, days])] ||= HistoricalData.new(ticker, days + Extra_Days)
      @high_prices = @historical_data.high_prices
      @low_prices = @historical_data.low_prices
      @close_prices = @historical_data.close_prices
    end

    def macd(ticker, period = 90, fast = 8, slow = 17, signal = 9)
      initialize(ticker, period)
      @macd_cache[cache_symbol(ticker, period, fast, slow, signal)] ||= MACD.new(fast, slow, signal, @historical_data)
    end

    def stochastic(ticker, period = 90, k = 14, d = 5)
      initialize(ticker, period)
      @stochastic_cache[cache_symbol(ticker, period, k, d)] ||= Stochastic.new(k, d, @historical_data)
    end

    def ema(ticker, period = 90, days = 10)
      initialize(ticker, period)
      @ema_cache[cache_symbol(ticker, period, days)] ||= EMA.new(days, @historical_data)
    end

    def get_signals(ticker, period = 90)
      puts "Generating default signals for #{ticker} over the last #{period} days:"
      last_macd = macd(ticker, period).macd_divergence_points[:divergence_points].last
      s = stochastic(ticker, period)
      e = ema(ticker, period)
      puts "MACD: #{last_macd}"
      puts "Slow Stochastic %k/%d: #{s.slow_stochastic[0].last} #{s.slow_stochastic[1].last}"
      puts "10-day EMA/Last Closing Price: #{e.emas.last} #{@close_prices.last}"
      puts "#{last_macd > 0 ? 'BUY' : 'SELL'} #{s.slow_stochastic[0].last > s.slow_stochastic[1].last ? 'BUY' : 'SELL'} #{e.emas.last < @close_prices.last ? 'BUY' : 'SELL'}"
    end

    def cache_symbol(*args)
      args.map(&:to_s)
      args.join('_').to_sym
    end

    #temp
    def generate_buy_and_sell_prices(macd, stochastic, ema)
      macd_points = macd.macd_divergence_points[:divergence_points]
      stochastic_points = stochastic.slow_stochastic
      ema_points = ema.emas
      close_prices = @close_prices
      size = [macd_points.size, stochastic_points[0].size, ema_points.size, close_prices.size].min
      macd_points.slice!(0..(macd_points.size - size))
      stochastic_points[0].slice!(0...(stochastic_points[0].size - size))
      stochastic_points[1].slice!(0...(stochastic_points[1].size - size))
      ema_points.slice!(0...(ema_points.size - size))
      close_prices.slice!(0...(close_prices.size - size))

      territory = nil
      first_buy = nil
      buy = nil
      sell = nil
      money = 1.0
      macd_points.each_with_index do |m, i|
#        puts "#{m}:#{stochastic_points[0][i]-stochastic_points[1][i]}:#{ema_points[i]-close_prices[i]}"
        if((m < 0.0) && (stochastic_points[0][i] - stochastic_points[1][i] < 0.0) && (ema_points[i] - close_prices[i] < 0.0))
          if territory && territory != "sell"
            territory = "sell"
#            puts "Sell at: #{close_prices[i]}"
            sell = close_prices[i]
            money *= (sell-buy)/buy+1.0
          end
        elsif((m >= 0.0) && (stochastic_points[0][i] - stochastic_points[1][i] >= 0.0) && (ema_points[i] - close_prices[i] >= 0.0))
          if territory != "buy"
            territory = "buy"
#            puts "Buy at: #{close_prices[i]}"
            buy = close_prices[i]
            first_buy = close_prices[i] unless first_buy
          end
        elsif territory == "buy" && close_prices[i] < buy * 0.97
          territory = sell
#          puts "Sell at: #{buy*0.97}"
          sell = buy*0.97
          money *= (sell-buy)/buy+1.0
        end
      end
      if territory == "buy"
        money *= (close_prices.last-buy)/buy+1.0
      end
      puts "Money with system: #{money}"
      puts "Money without system: #{(sell-first_buy)/buy+1.0}" rescue puts "Money without system: #{(close_prices.last-close_prices.first)/close_prices.first+1.0}"
    end
  end
end
