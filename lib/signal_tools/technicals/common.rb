require './lib/signal_tools/technicals/common'

module SignalTools
  module Technicals
    module Common
      def trim_data_to_range(data, size)
        if data.is_a?(Array)
          data.last(size)
        elsif data.is_a?(Hash)
          data.keys.each { |key| data[key] = data[key].first(size) }
          data
        end
      end

      # Gets the first 0...period of numbers from data and returns a simple average.
      def default_simple_average(data, period)
        SignalTools.average(data.slice(0...period))
      end

      #Runs method for the given slice of the array.
      def get_for_period(points, start, finish, method)
        case method
          when :average
            SignalTools.average(points.slice(start..finish))
          else
            (points.slice(start..finish)).send(method)
          end
      end

      #Returns a collection of values by iterating over an array, slicing it period
      # elements at a time and calling method for each slice.
      def collection_for_array(points, period, method)
        raise unless points.size >= period
        collection = []
        index = 0
        while((index + period - 1) < points.size)
          collection << get_for_period(points, index, (index + period - 1), method)
          index += 1
        end
        collection
      end
    end
  end
end