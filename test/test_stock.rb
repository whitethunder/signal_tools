require 'test_helper'
require 'signal_tools'

class TestStock < Test::Unit::TestCase
  def setup
    ticker = "TESTING"
    @days = 30
    flexmock(YahooFinance).should_receive(:get_historical_quotes).with_any_args.and_return(test_data(@days))
    @stock = SignalTools::Stock.new(ticker)
  end

  def test_ema
    assert_equal "2.344948", "%.6f" % @stock.ema[-1]
    assert_equal "2.736776", "%.6f" % @stock.ema[-5]
    assert_equal "2.556322", "%.6f" % @stock.ema(25)[-1]
    assert_equal "2.705835", "%.6f" % @stock.ema(25)[-5]
  end

  def test_macd
    assert_equal "-0.034645", "%.6f" % @stock.macd[:signal_points][-1]
    assert_equal "-0.018762", "%.6f" % @stock.macd[:signal_points][-5]
    assert_equal "-0.195043", "%.6f" % @stock.macd[:divergences][-1]
    assert_equal "0.063532",  "%.6f" % @stock.macd[:divergences][-5]

    assert_equal "-0.022654", "%.6f" % @stock.macd(12, 26, 9)[:signal_points][-1]
    assert_equal "-0.014099", "%.6f" % @stock.macd(12, 26, 9)[:signal_points][-5]
    assert_equal "-0.136291", "%.6f" % @stock.macd(12, 26, 9)[:divergences][-1]
    assert_equal "0.034219",  "%.6f" % @stock.macd(12, 26, 9)[:divergences][-5]
  end

  def test_fast_stochastic
    assert_equal "0.057143", "%.6f" % @stock.fast_stochastic[:k][-1]
    assert_equal "0.571429", "%.6f" % @stock.fast_stochastic[:k][-5]
    assert_equal "0.314286", "%.6f" % @stock.fast_stochastic[:d][-1]
    assert_equal "0.314286", "%.6f" % @stock.fast_stochastic[:d][-5]

    assert_equal "0.057143", "%.6f" % @stock.fast_stochastic(12, 3)[:k][-1]
    assert_equal "0.571429", "%.6f" % @stock.fast_stochastic(12, 3)[:k][-5]
    assert_equal "0.185714", "%.6f" % @stock.fast_stochastic(12, 3)[:d][-1]
    assert_equal "0.271429", "%.6f" % @stock.fast_stochastic(12, 3)[:d][-5]
  end

  def test_slow_stochastic
    assert_equal "0.185714", "%.6f" % @stock.slow_stochastic[:k][-1]
    assert_equal "0.271429", "%.6f" % @stock.slow_stochastic[:k][-5]
    assert_equal "0.314286", "%.6f" % @stock.slow_stochastic[:d][-1]
    assert_equal "0.314286", "%.6f" % @stock.slow_stochastic[:d][-5]

    assert_equal "0.185714", "%.6f" % @stock.slow_stochastic(12, 3)[:k][-1]
    assert_equal "0.271429", "%.6f" % @stock.slow_stochastic(12, 3)[:k][-5]
    assert_equal "0.314286", "%.6f" % @stock.slow_stochastic(12, 3)[:d][-1]
    assert_equal "0.257143", "%.6f" % @stock.slow_stochastic(12, 3)[:d][-5]
  end

  def test_atr
    assert_equal "3.195750", "%.6f" % @stock.atr[-1]
    assert_equal "3.438910", "%.6f" % @stock.atr[-5]
    assert_equal "3.208282", "%.6f" % @stock.atr(15)[-1]
    assert_equal "3.434397", "%.6f" % @stock.atr(15)[-5]
  end

  def test_adx
    assert_equal "0.491321", "%.6f" % @stock.adx[-1]
    assert_equal "0.496588", "%.6f" % @stock.adx[-5]
  end
end
