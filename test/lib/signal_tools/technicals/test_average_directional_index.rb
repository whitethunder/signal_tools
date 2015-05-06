require './test/test_helper'

class TestAverageDirectionalIndex < Minitest::Test
  def setup
    ticker = "TESTING"
    @days = 90

    YahooFinance.stub(:get_historical_quotes, data_for_tests(@days)) do
      @stock = SignalTools::Stock.new(ticker)
    end

    @stock_data = @stock.stock_data
  end

  def test_calculate
    assert_equal "0.491321", "%.6f" % SignalTools::Technicals::AverageDirectionalIndex.new(@stock_data, 14).calculate[-1]
    assert_equal "0.496588", "%.6f" % SignalTools::Technicals::AverageDirectionalIndex.new(@stock_data, 14).calculate[-5]
  end
end