class AverageTrueRange < Common
  attr_reader :average_true_range
  # Number of days to get an initial seed average for average true range
  #TODO: We need at least 66 days of seed data to start generating accurate results
  Average_True_Range_Seed_Days = 14

  def initialize(from_date, days, historical_data)
    super(historical_data)
    average_true_ranges(from_date, days)
  end

  # Takes a Date object and number of days to compute ATR for and returns a hash of Date => ATR values.
  def average_true_ranges(from_date, days)
    #ATR = ((PrevATR * 13) + TodayATR) / 14
    true_ranges = {from_date => average_true_range_seed(from_date)}
    dates = dates_for_period(from_date, days)
    (1...(dates.size)).each { |index| true_ranges[dates[index]] = (true_ranges[dates[index-1]] * (days-1) + true_range(@date_prices[dates[index]], @date_prices[dates[index-1]])) / days.to_f }
    @average_true_range = true_ranges
  end

  private

  # Takes a date_price hash for today and yesterday and returns the true range.
  def true_range(today, yesterday)
    [
      today[High] - today[Low],
      (today[High] - yesterday[Close]).abs,
      (today[Low] - yesterday[Close]).abs
    ].max
  end

  # Computes the default average true range (high - low), then a simple average of 14 days of true ranges to seed the average true range.
  def average_true_range_seed(from_date)
    seed_dates = dates_for_previous_period(from_date, Average_True_Range_Seed_Days)
    seed_true_ranges = [seed_dates.first[High] - seed_dates.first[Low]]
    (1...(seed_dates.size)).each { |index| seed_true_ranges << true_range(@date_prices[seed_dates[index]], @date_prices[seed_dates[index-1]]) }
    seed_true_ranges.average
  end
end
