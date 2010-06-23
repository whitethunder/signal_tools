class ATR < Common
  attr_reader :atrs
  # Number of days to get an initial seed average for average true range

  def initialize(ticker, period, historical_data)
    super(ticker, historical_data)
    get_average_true_ranges(period, historical_data)
  end

  private

  def get_average_true_ranges(period, data)
    @atrs = average_true_ranges(period, data)
  end
end
