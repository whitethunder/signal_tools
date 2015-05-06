require './test/test_helper'

class TestFastStochastic < Minitest::Test
  def setup
    ticker = "TESTING"
    @days = 90

    YahooFinance.stub(:get_historical_quotes, data_for_tests(@days)) do
      @stock = SignalTools::Stock.new(ticker)
    end

    @stock_data = @stock.stock_data
  end

  def test_calculate
    assert_equal "0.057143", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 14, 5).calculate[:k][-1]
    assert_equal "0.571429", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 14, 5).calculate[:k][-5]
    assert_equal "0.314286", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 14, 5).calculate[:d][-1]
    assert_equal "0.314286", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 14, 5).calculate[:d][-5]

    assert_equal "0.057143", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 12, 3).calculate[:k][-1]
    assert_equal "0.571429", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 12, 3).calculate[:k][-5]
    assert_equal "0.185714", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 12, 3).calculate[:d][-1]
    assert_equal "0.271429", "%.6f" % SignalTools::Technicals::FastStochastic.new(@stock_data, 12, 3).calculate[:d][-5]
  end
end