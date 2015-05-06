require './test/test_helper'

class TestStock < Minitest::Test
  def setup
    ticker = "TESTING"
    @days = 90

    YahooFinance.stub(:get_historical_quotes, data_for_tests(@days)) do
      @stock = SignalTools::Stock.new(ticker)
    end
  end

  def test_stock_should_have_correct_number_of_data_elements
    assert_equal(@days, @stock.dates.size)
    assert_equal(@days, @stock.ema.size)
    assert_equal(@days, @stock.macd[:divergences].size)
    assert_equal(@days, @stock.fast_stochastic[:k].size)
    assert_equal(@days, @stock.slow_stochastic[:k].size)
    assert_equal(@days, @stock.average_true_range.size)
    assert_equal(@days, @stock.average_directional_index.size)
  end
end
