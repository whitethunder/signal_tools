class AverageTrueRange < Common
  attr_reader :average_true_range
  # Number of days to get an initial seed average for average true range
  Average_True_Range_Seed_Days = 14

  def initialize(from_date, days, historical_data)
    super(historical_data)
    average_true_ranges(from_date, days)
  end

  # Takes a Date object and number of days to compute ATR for and returns a hash of Date => ATR values.
  def average_true_ranges(from_date, days)
    @average_true_range = {from_date => average_true_range_seed(from_date, days)}
    dates = dates_for_period(from_date, days)
    (1...(dates.size)).each { |index| @average_true_range[dates[index]] = calculate_average_true_range(@date_prices[dates[index]], @date_prices[dates[index-1]], @average_true_range[dates[index-1]], days) }
    @average_true_range
  end

  private

  # Takes a date_price hash for today and yesterday, yesterday's average true range, and a period of days and returns the average true range.
  def calculate_average_true_range(today, yesterday, yesterday_atr, days)
    #ATR = ((PrevATR * 13) + TodayTR) / 14
    (yesterday_atr * (days - 1) + true_range(today, yesterday)) / days
  end

  # Takes a date_price hash for today and yesterday and returns the true range.
  def true_range(today, yesterday)
    [
      today[High] - today[Low],
      (today[High] - yesterday[Close]).abs,
      (today[Low] - yesterday[Close]).abs
    ].max
  end

  # Takes the date of interest in YYYY-MM-DD format and a number of days and computes the seed average true value by taking a simple average of days true range values. We add a buffer of HistoricalData::Extra_Days in order to get more accurate results.
  def average_true_range_seed(from_date, days)
    seed_dates = dates_for_previous_period(from_date, HistoricalData::Extra_Days)
    seed_true_ranges = [average_true_range_initial_simple_average(seed_dates.slice(0, Average_True_Range_Seed_Days))]
    (Average_True_Range_Seed_Days...(seed_dates.size)).each { |index| seed_true_ranges << calculate_average_true_range(@date_prices[seed_dates[index]], @date_prices[seed_dates[index-1]], seed_true_ranges.last, days) }
    seed_true_ranges.last
  end

  # Takes a simple average of the true ranges for dates, which is an array of dates in YYYY-MM-DD format.
  def average_true_range_initial_simple_average(dates)
    initial_true_ranges = [default_true_range(dates.first)]
    (1...(dates.size)).each { |index| initial_true_ranges << true_range(@date_prices[dates[index]], @date_prices[dates[index-1]]) }
    initial_true_ranges.average
  end

  # Returns the default true range seed value, which is just (high - low) for the given date.
  def default_true_range(date)
    @date_prices[date][High] - @date_prices[date][Low]
  end
end
