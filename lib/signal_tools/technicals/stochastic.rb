require './lib/signal_tools/technicals/common'

module SignalTools::Technicals::Stochastic
  include ::SignalTools::Technicals::Common

  attr_reader :d_period, :k_period, :stock_data

  def calculate_d_points(k_points, period)
    collection_for_array(k_points, period, :average)
  end

  def k_d_points(k_points, d_points)
    raise unless k_points.size > d_points.size
    SignalTools.truncate_to_shortest!(k_points, d_points)
    {:k => k_points, :d => d_points}
  end

  def fast_stochastic_points
    k_points = calculate_fast_stochastic_k_points
    d_points = calculate_d_points(k_points, d_period)
    k_d_points(k_points, d_points)
  end

  def calculate_fast_stochastic_k_points
    index = 0
    points = []
    while((index + k_period) <= stock_data.close_prices.size)
      today_cp = stock_data.close_prices[index + k_period - 1]
      low_price = get_for_period(stock_data.low_prices, index, index + k_period - 1, :min)
      high_price = get_for_period(stock_data.high_prices, index, index + k_period - 1, :max)
      points << (today_cp - low_price) / (high_price - low_price)
      index += 1
    end
    points
  end
end