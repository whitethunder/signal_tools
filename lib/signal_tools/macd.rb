class MACD < Common
  attr_reader :macd, :divergence
  #Divergence turns to negative: sell
  #Divergence turns to positive: buy

  def initialize(ticker, fast, slow, signal, historical_data)
    super(ticker, historical_data)
    get_macd_points(fast, slow, signal, @close_prices)
  end

  private

  # Takes a period of days for fast, slow, signal, and time period (eg 8,17,9).
  def get_macd_points(fast, slow, signal, data)
    fast_ema_points = get_ema_points(fast, data)
    slow_ema_points = get_ema_points(slow, data)
    @macd, @divergence = get_macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
  end

  def get_macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
    macd_points = get_differences(fast_ema_points, slow_ema_points)
    signal_points = get_ema_points(signal, macd_points)
    divergences = get_differences(macd_points, signal_points)
    [signal_points, divergences]
  end

  # Returns an array with the differences between the first_points and second_points
  def get_differences(first_points, second_points)
    Array.truncate_to_shortest!(first_points, second_points)
#    if first_points.size > second_points.size
#      first_points.slice!(0...(first_points.size - second_points.size))
#    elsif second_points.size > first_points.size
#      second_points.slice!(0...(second_points.size - first_points.size))
#    end
    differences = []
    first_points.each_with_index { |fp, index| differences << fp - second_points[index] }
    differences
  end
end
