require './lib/signal_tools/technicals/stochastic'

module SignalTools::Technicals
  class SlowStochastic
    include Stochastic

    SMA_DEFAULT = 3

    def initialize(stock_data, k_period, d_period)
      @d_period = d_period
      @k_period = k_period
      @stock_data = stock_data
    end

    def calculate
      # trim_data_to_range!(slow_stochastic_points(k_period, d_period))
      slow_stochastic_points
    end

    def slow_stochastic_points
      fast_points = fast_stochastic_points
      k_points = slow_k_points(fast_points[:k])
      slow_d_points = calculate_d_points(k_points, d_period)
      k_d_points(k_points, slow_d_points)
    end

    def slow_k_points(fast_k_points)
      collection_for_array(fast_k_points, SMA_DEFAULT, :average)
    end
  end
end