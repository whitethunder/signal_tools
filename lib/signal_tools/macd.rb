class MACD < Common
  attr_reader :macd, :divergence
  #Divergence turns to negative: sell
  #Divergence turns to positive: buy

  def initialize(ticker, fast, slow, signal, historical_data)
    super(ticker, historical_data)
    get_macd_points(fast, slow, signal)
  end

  private

  # Takes a period of days for fast, slow, signal, and time period (eg 8,17,9).
  def get_macd_points(fast, slow, signal)
    fast_ema_points = get_ema_points(fast, @close_prices)
    slow_ema_points = get_ema_points(slow, @close_prices)
    @macd, @divergence = get_macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
  end

  def get_macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
    macd_points = get_differences(fast_ema_points, slow_ema_points)
    signal_points = get_ema_points(signal, macd_points)
    divergences = get_differences(macd_points, signal_points)
    [macd_points, divergences]
  end

  # Returns an array with the differences between the first_points and second_points
  def get_differences(first_points, second_points)
    if first_points.size > second_points.size
      first_points.slice!(0...(first_points.size - second_points.size))
    elsif second_points.size > first_points.size
      second_points.slice!(0...(second_points.size - first_points.size))
    end
    first_points.map { |fast| fast - second_points.shift }
  end
end
