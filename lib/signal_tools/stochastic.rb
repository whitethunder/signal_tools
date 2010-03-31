class Stochastic < Common
  #Fast Stochastic
  #14/5
  #fast %K = (Today's CP - Low CP(14)) / (High CP(14) - Low CP(14))
  #fast %D = average(fast %k, 5)
  #Place days on horizontal axis, 0-100% on vertical axis

  #Slow Stochastic
  #slow %K = fast %D
  #slow %D = average(fast %D, 5)
  attr_reader :fast_stochastic, :slow_stochastic
  Slow_K_SMA = 3

  def initialize(k, d, historical_data)
    super(historical_data)
    get_stochastic_points(k, d)
  end

  def get_stochastic_points(k_period, d_period)
    fast_k_points = calculate_fast_stochastic_k_points(k_period)
    fast_d_points = calculate_d_points(fast_k_points, d_period)
    @fast_stochastic = get_k_d_points(fast_k_points, fast_d_points)
    @slow_stochastic = get_slow_stochastic_points(d_period)
  end

  private

  def calculate_fast_stochastic_k_points(period)
    index = 0
    points = []
    while((index + period) <= @close_prices.size)
      today_cp = @close_prices[index + period - 1]
      low_price = get_for_period(@low_prices, index, index + period - 1, :min)
      high_price = get_for_period(@high_prices, index, index + period - 1, :max)
      points << (today_cp - low_price) / (high_price - low_price)
      index += 1
    end
    points
  end

  def get_slow_stochastic_points(d_period)
    raise unless @fast_stochastic
    slow_k_points = get_slow_k_points(@fast_stochastic[0])
    slow_d_points = calculate_d_points(slow_k_points, d_period)
    get_k_d_points(slow_k_points, slow_d_points)
  end

  def calculate_d_points(k_points, period)
    get_collection_for_array(k_points, period, :average)
  end

  def get_k_d_points(k_points, d_points)
    raise unless k_points.size > d_points.size
    k_points = k_points.slice((k_points.size - d_points.size)..-1)
    [k_points, d_points]
  end

  def get_slow_k_points(fast_k_points)
    get_collection_for_array(fast_k_points, Slow_K_SMA, :average)
  end
end
