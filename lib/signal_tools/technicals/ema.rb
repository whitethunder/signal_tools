require './lib/signal_tools/technicals/common'

module SignalTools::Technicals
  class EMA
    include Common

    EMA_DEFAULT = 10

    attr_reader :data, :period, :type

    def initialize(data, period, type=:default)
      @data = data
      @period = period
      @type = type
    end

    def calculate
      ema_points
    end

    private

    #TODO: Break Wilder into its own class
    def ema_points
      emas = [default_simple_average(data, EMA_DEFAULT)]
      if type == :wilder
        data.slice(EMA_DEFAULT..-1).each { |current| emas << calculate_wilder_ema(emas.last, current) }
      else
        data.slice(EMA_DEFAULT..-1).each { |current| emas << calculate_ema(emas.last, current) }
      end
      emas
    end

    #Takes current value, previous day's EMA, and number of days. Returns EMA for that day.
    def calculate_ema(previous, current)
      (current - previous) * (2.0 / (period + 1)) + previous
    end

    #Uses Wilder's moving average formula.
    def calculate_wilder_ema(previous, current)
      (previous * (period - 1) + current) / period
    end
  end
end
