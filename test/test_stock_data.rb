require 'test_helper'
require 'signal_tools'

class TestStockData < Test::Unit::TestCase
  def setup
    ticker = "TESTING"
    @days = 90
    @total_days = @days + SignalTools::StockData::Extra_Days
    @from_date = Date.today - @days
    @to_date = Date.today
    flexmock(YahooFinance).should_receive(:get_historical_quotes).with_any_args.and_return(data_for_tests(@days))
    @stock_data = SignalTools::StockData.new(ticker, @from_date, @to_date)
  end

  def test_dates
    new_dates = []
    (0...@days).each { |i| new_dates.unshift(@to_date - i) }
    assert_equal new_dates, @stock_data.dates
  end

  def test_open_prices
    result = @stock_data.open_prices.delete_if { |e| !e.is_a?(Float) }
    assert_equal @total_days, result.size
  end

  def test_high_prices
    result = @stock_data.high_prices.delete_if { |e| !e.is_a?(Float) }
    assert_equal @total_days, result.size
  end

  def test_low_prices
    result = @stock_data.low_prices.delete_if { |e| !e.is_a?(Float) }
    assert_equal @total_days, result.size
  end

  def test_close_prices
    result = @stock_data.close_prices.delete_if { |e| !e.is_a?(Float) }
    assert_equal @total_days, result.size
  end
end
