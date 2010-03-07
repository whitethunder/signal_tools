class Common
  High = 0
  Low = 1
  Close = 2
  attr_accessor :ticker, :period, :date_prices, :high_prices, :low_prices, :close_prices

  def initialize(historical_data)
    @ticker = historical_data.ticker
    @period = historical_data.period
    @date_prices  = historical_data.date_prices
    @high_prices  = historical_data.high_prices
    @low_prices   = historical_data.low_prices
    @close_prices = historical_data.close_prices
  end

  def get_ema_points(prices, ema_period)
    previous = calculate_sma(prices.slice(0...ema_period))
    emas = []
    prices.slice(ema_period..-1).each do |price|
      previous = calculate_ema(price, previous, ema_period)
      emas << previous
    end
    emas
  end

  #Takes current value, previous day's EMA, and number of days. Returns EMA for
  #that day.
  def calculate_ema(current, previous_ema, period)
    (current - previous_ema) * (2.0 / (period + 1)) + previous_ema
  end

  def calculate_sma(prices)
    prices.average
  end

  def get_collection_for_array(points, period, method)
    raise unless points.size >= period
    collection = []
    index = 0
    while((index + period - 1) < points.size)
      collection << points.slice(index..(index + period - 1)).send(method)
      index += 1
    end
    collection
  end

  def get_for_period(prices, start, finish, method)
    prices.slice(start..finish).send(method)
  end
end
