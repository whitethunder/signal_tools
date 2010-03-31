class MACD < Common
  attr_reader :macd_divergence_points
  #Divergence turns to negative: sell
  #Divergence turns to positive: buy

  def initialize(fast, slow, signal, historical_data)
    super(historical_data)
    get_macd_points(fast, slow, signal)
  end

  #Takes a period of days for fast, slow, signal, and time period (eg 8,17,9).
  def get_macd_points(fast, slow, signal)
    price_period = [fast, slow, signal, @period].max
    # We require about 45 extra data points to get the first desired point accurate.
    # In the future when we store all this information, we can just seed it and then
    # calculate from the desired point
    fast_ema_points = get_ema_points(@close_prices, fast)
    slow_ema_points = get_ema_points(@close_prices, slow)
    @macd_divergence_points = get_macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
  end

  private

  def get_macd_and_divergence_points(fast_ema_points, slow_ema_points, signal)
    differences = get_fast_slow_differences(fast_ema_points, slow_ema_points)
    macd_points = calculate_macd_points(differences, signal)
    divergences = calculate_divergence_points(differences, macd_points)
    {:macd_points => macd_points, :divergence_points => divergences}
  end

  def calculate_divergence_points(differences, macd_points)
    raise if differences.size != macd_points.size
    divergences = []
    (0...(differences.size)).each do |i|
      divergences << differences[i] - macd_points[i]
    end
    divergences
  end

  def calculate_macd_points(differences, signal_period)
    previous = 0
    points = []
    differences.each do |d|
      previous = ((d - previous) * (2.0 / (signal_period + 1)) + previous)
      points << previous
    end
    points
  end

  # Returns an array with the differences between the fast and slow points
  def get_fast_slow_differences(fast_points, slow_points)
    raise unless fast_points.size > slow_points.size
    fast_points.slice!(0...(fast_points.size - slow_points.size))
    points = []
    (0...(fast_points.size)).each do |i|
      points << fast_points[i] - slow_points[i]
    end
    points
  end
end
