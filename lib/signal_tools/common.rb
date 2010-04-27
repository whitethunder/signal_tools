class Common
  # Positions of prices in @date_prices
  High = 0
  Low = 1
  Close = 2

  attr_reader :ticker, :date, :date_prices, :high_prices, :low_prices, :close_prices

  def initialize(historical_data)
    @ticker = historical_data.ticker
    @date = historical_data.date
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

  def get_for_period(points, start, finish, method)
    points.slice(start..finish).send(method)
  end

  def get_collection_for_array(points, period, method)
    raise unless points.size >= period
    collection = []
    index = 0
    while((index + period - 1) < points.size)
      collection << get_for_period(points, index, (index + period - 1), method)
      index += 1
    end
    collection
  end

  # Determine date of the trading day that is 'days' before date, where date is a Date object.
  def date_for_trading_day_before(date, days)
    dates = sorted_date_price_keys
    index = dates.index(date.strftime)
    raise "Not enough historical data for period" if(index - days) < 0
    dates[index - days]
  end

  # Returns dates in YYYY-MM-DD format for a specified period.
  def dates_for_period(start_date, days)
    dates = sorted_date_price_keys
    dates.slice(dates.index(start_date), days)
  end

  def dates_for_previous_period(date, previous_days)
    index = sorted_date_price_keys.index(date)
    raise "Not enough historical data for period" if(index - previous_days) < 0
    sorted_date_price_keys.slice(index - previous_days, index)
  end

  def sorted_date_price_keys
    @sorted_dpks ||= @date_prices.keys.sort
  end
end
