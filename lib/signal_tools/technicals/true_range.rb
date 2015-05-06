module SignalTools
  module Technicals
    module TrueRange
      # Takes historical data and computes the true ranges.
      def true_ranges(stock_data)
        trs = [stock_data.high_prices.first - stock_data.low_prices.first]
        index = 1
        while index < (stock_data.high_prices.size)
          trs << true_range(stock_data.raw_data[index], stock_data.raw_data[index-1])
          index += 1
        end
        trs
      end

      # Takes today's data and yesterday's data and computes the true range.
      def true_range(today, yesterday)
        [
          today[SignalTools::StockData::Indexes[:high]] - today[SignalTools::StockData::Indexes[:low]],
          (yesterday[SignalTools::StockData::Indexes[:close]] - today[SignalTools::StockData::Indexes[:high]]).abs,
          (yesterday[SignalTools::StockData::Indexes[:close]] - today[SignalTools::StockData::Indexes[:low]]).abs
        ].max
      end
    end
  end
end