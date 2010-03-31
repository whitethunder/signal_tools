class HistoricalData
  require 'signal_tools/webpage'
  attr_accessor :ticker, :period, :date_prices, :high_prices, :low_prices, :close_prices
  #http://ichart.finance.yahoo.com/table.csv?s=YHOO&d=0&e=13&f=2010&g=d&a=3&b=13&c=1996&ignore=.csv
  #a = start month 0 based
  #b = start day
  #c = start year
  #d = end month 0 based
  #e = end day
  #f = end year
  #g = (d)aily, (w)eekly
  #Downloads historical prices and returns them as a hash in the format of {date => [prices]}
  def initialize(ticker, days)
    #TODO: allow data retrieval from an arbitrary date
    @ticker = ticker
    @period = days
    @date_prices, @high_prices, @low_prices, @close_prices = {}, [], [], []
    @origin_date = Date.today - days
    @start_month = @origin_date.month - 1 # For whatever reason, months are 0-based
    @start_day = @origin_date.day
    @start_year = @origin_date.year
    @end_month = Date.today.month - 1
    @end_day = Date.today.day
    @end_year = Date.today.year
    @frequency = "d"
  end

  def date_prices
    retrieve_historical_prices if @date_prices.size == 0
    @date_prices
  end

  def high_prices
    retrieve_historical_prices if @high_prices.size == 0
    @high_prices
  end

  def low_prices
    retrieve_historical_prices if @low_prices.size == 0
    @low_prices
  end

  def close_prices
    retrieve_historical_prices if @close_prices.size == 0
    @close_prices
  end

  private

  def retrieve_historical_prices
    csv = Webpage.new("http://ichart.finance.yahoo.com/table.csv?s=#{@ticker}&d=#{@end_month}&e=#{@end_day}&f=#{@end_year}&g=#{@frequency}&a=#{@start_month}&b=#{@start_day}&c=#{@start_year}&ignore=.csv").page.text
    extract_prices(csv)
  end

  def extract_prices(file)
#    Date,Open,High,Low,Close,Volume,Adj Close
    lines = file.split("\n")
    lines.shift
    lines.reverse_each do |line|
      line = line.split(",")
      @date_prices[line[0]] = [line[2].to_f, line[3].to_f, line[4].to_f]
      @high_prices << line[2].to_f
      @low_prices << line[3].to_f
      @close_prices << line[4].to_f
    end
  end
end
