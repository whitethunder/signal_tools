require 'yahoofinance'

module SignalTools
  class StockData
    # Extra days needed to produce accurate data for the desired date.
    Extra_Days = 365
    Indexes = {
      :date           => 0,
      :open           => 1,
      :high           => 2,
      :low            => 3,
      :close          => 4,
      :volume         => 5,
      :adjusted_close => 6
    }
    attr_reader :raw_data

    #Downloads historical prices using the YahooFinance gem.
    def initialize(ticker, from_date, to_date)
      @raw_data = YahooFinance::get_historical_quotes(ticker, from_date, to_date).reverse
    end

    def dates
      @dates ||= @raw_data.map { |d| d[Indexes[:date]] }
    end

    def open_prices
      @open_prices ||= @raw_data.map { |d| d[Indexes[:open]] }
    end

    def high_prices
      @high_prices ||= @raw_data.map { |d| d[Indexes[:high]] }
    end

    def low_prices
      @low_prices ||= @raw_data.map { |d| d[Indexes[:low]] }
    end

    def close_prices
      @close_prices ||= @raw_data.map { |d| d[Indexes[:close]] }
    end
  end
end
