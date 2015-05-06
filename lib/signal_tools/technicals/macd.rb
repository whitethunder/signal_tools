module SignalTools
  module Technicals
    class MACD
      attr_reader :fast, :slow, :signal, :data

      def initialize(data, fast, slow, signal)
        @data = data
        @fast = fast
        @slow = slow
        @signal = signal
      end

      def calculate
        # trim_data_to_range!(macd_points)
        macd_points
      end

      # Takes a period of days for fast, slow, signal, and time period (eg 8,17,9).
      def macd_points
        fast_ema_points = SignalTools::Technicals::EMA.new(data, fast).calculate
        slow_ema_points = SignalTools::Technicals::EMA.new(data, slow).calculate
        macd_and_divergence_points(fast_ema_points, slow_ema_points)
      end

      def macd_and_divergence_points(fast_ema_points, slow_ema_points)
        macds = differences_between_arrays(fast_ema_points, slow_ema_points)
        signal_points = SignalTools::Technicals::EMA.new(macds, signal).calculate
        divergences = differences_between_arrays(macds, signal_points)
        {:signal_points => signal_points, :divergences => divergences}
      end

      # Returns an array with the differences between the first_points and second_points
      def differences_between_arrays(first_points, second_points)
        SignalTools.truncate_to_shortest!(first_points, second_points)
        differences = []
        first_points.each_with_index { |fp, index| differences << fp - second_points[index] }
        differences
      end
    end
  end
end