require './test/test_helper'

class TestMACD < Minitest::Test
  def setup
    ticker = "TESTING"
    @days = 90

    YahooFinance.stub(:get_historical_quotes, data_for_tests(@days)) do
      @data = SignalTools::Stock.new(ticker)
    end

    @data = @data.stock_data.close_prices
  end

  def test_calculate
    assert_equal "-0.034645", "%.6f" % SignalTools::Technicals::MACD.new(@data, 8, 17, 9).calculate[:signal_points][-1]
    assert_equal "-0.018762", "%.6f" % SignalTools::Technicals::MACD.new(@data, 8, 17, 9).calculate[:signal_points][-5]
    assert_equal "-0.195043", "%.6f" % SignalTools::Technicals::MACD.new(@data, 8, 17, 9).calculate[:divergences][-1]
    assert_equal "0.063532",  "%.6f" % SignalTools::Technicals::MACD.new(@data, 8, 17, 9).calculate[:divergences][-5]

    assert_equal "-0.022654", "%.6f" % SignalTools::Technicals::MACD.new(@data, 12, 26, 9).calculate[:signal_points][-1]
    assert_equal "-0.014099", "%.6f" % SignalTools::Technicals::MACD.new(@data, 12, 26, 9).calculate[:signal_points][-5]
    assert_equal "-0.136291", "%.6f" % SignalTools::Technicals::MACD.new(@data, 12, 26, 9).calculate[:divergences][-1]
    assert_equal "0.034219",  "%.6f" % SignalTools::Technicals::MACD.new(@data, 12, 26, 9).calculate[:divergences][-5]
  end
end