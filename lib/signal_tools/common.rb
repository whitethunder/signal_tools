class Common
  #TODO: truncate historical data in the case where it's really long (if this is applicable)
  Date           = 0
  Open           = 1
  High           = 2
  Low            = 3
  Close          = 4
  Volume         = 5
  Adjusted_Close = 6
  EMA_Seed_Days  = 10
  attr_reader :ticker, :high_prices, :low_prices, :close_prices #,:historical_data, :open_prices

  def initialize(ticker, historical_data)
    @open_prices, @high_prices, @low_prices, @close_prices = [], [], [], []
    @ticker = ticker
#    @historical_data = historical_data
#    @date = historical_data.date

# TODO: seperate these into their own methods?
    historical_data.each do |hd|
#      @open_prices  << hd[Open].to_f
      @high_prices  << hd[High].to_f
      @low_prices   << hd[Low].to_f
      @close_prices << hd[Close].to_f
#      @volumes      << [hd[Date], hd[Volume]]
    end
  end

  def get_ema_points(period, data)
    calculate_emas_for_data(period, data)
#    dates = sorted_date_price_keys
#    from_date_index = sorted_date_price_keys.index(from_date)
#    emas = calculate_emas_for_dates(dates.slice((from_date_index - HistoricalData::Extra_Days + EMA_Seed_Days)..-1), get_ema_default(from_date_index), ema_period)
#    emas.delete_if { |k,v| k < from_date }
  end

  #Iterates over a data set and calculates the exponential moving average for
  #each point.
  def calculate_emas_for_data(period, data)
    emas = [get_ema_default(data)]
    data.slice(EMA_Seed_Days..-1).each { |current| emas << calculate_ema(emas.last, current, period) }
    emas
  end

  # Gets the first EMA_Seed_Days of numbers from data and returns a simple average.
  def get_ema_default(data)
    data.slice(0...EMA_Seed_Days).average
  end

  #Takes current value, previous day's EMA, and number of days. Returns EMA for
  #that day.
  def calculate_ema(previous, current, period)
    (current - previous) * (2.0 / (period + 1)) + previous
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

#  # Determine date of the trading day that is 'days' before date, where date is a Date object.
#  def date_for_trading_day_before(date, days)
#    dates = sorted_date_price_keys
#    index = dates.index(date.strftime)
#    raise "Not enough historical data for period" if(index - days) < 0
#    dates[index - days]
#  end

#  # Returns dates in YYYY-MM-DD format for a specified period.
#  def dates_for_period(start_date, days)
#    dates = sorted_date_price_keys
#    dates.slice(dates.index(start_date), days)
#  end

#  # Gets all the dates for previous_days before and including date.
#  def dates_for_previous_period(date, previous_days)
#    index = sorted_date_price_keys.index(nearest_future_date(date))
#    raise "Not enough historical data for period" if(index - previous_days) < 0
#    sorted_date_price_keys.slice(index - previous_days + 1, previous_days)
#  end

#  # Since @date_prices is a hash but we sometimes need to iterate over it in order, this method gets the keys in sorted order and caches them for teh speedz.
#  def sorted_date_price_keys
#    @sorted_dpks ||= @date_prices.keys.sort
#  end

#  # Takes the data from the subclass and truncates it to date.
#  def truncate_data(data)
#    data.delete_if { |k,v| k < date }
#  end

#  # Gets the nearest future date (be it today or in the future) to date.
#  def nearest_future_date(date)
#    date = Date.parse(date)
#    0.upto(5) { |i| return (date+i).to_s if sorted_date_price_keys.include?((date+i).to_s) }
#  end
end
