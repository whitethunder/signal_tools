require 'test_helper'
require 'signal_tools'

class SignalToolsTest < Test::Unit::TestCase

  def setup
    @ticker = "TESTING"
    @period = 90
    setup_historical_data(@ticker, @period)
    # Get number of trading days in period. Find first three days that should be
    # accurate to 6 decimals, then compare with the last 3 days since we are repeating
    # 3 numbers in historical data.
    @accuracy_period_start = (@period - (@period / 7) * 2)
    @accuracy_period_start += case (@accuracy_period_start % 3)
      when 0 : 1
      when 1 : 0
      when 2 : 2
    end
  end

  def test_ema_should_return_valid_correct_emas
    ema = SignalTools.ema(@ticker, @period)
    assert_equal("%.6f" % ema.emas[-@accuracy_period_start], "%.6f" % ema.emas[-1])
    assert_equal("%.6f" % ema.emas[-@accuracy_period_start-1], "%.6f" % ema.emas[-2])
    assert_equal("%.6f" % ema.emas[-@accuracy_period_start-2], "%.6f" % ema.emas[-3])
  end

  def test_macd_should_return_valid_and_correct_macd_and_divergence_points
    macd = SignalTools.macd(@ticker, @period)
    assert_equal("%.6f" % macd.macd_divergence_points[:macd_points][-@accuracy_period_start], "%.6f" % macd.macd_divergence_points[:macd_points][-1])
    assert_equal("%.6f" % macd.macd_divergence_points[:macd_points][-@accuracy_period_start-1], "%.6f" % macd.macd_divergence_points[:macd_points][-2])
    assert_equal("%.6f" % macd.macd_divergence_points[:macd_points][-@accuracy_period_start-2], "%.6f" % macd.macd_divergence_points[:macd_points][-3])
    assert_equal("%.6f" % macd.macd_divergence_points[:divergence_points][-@accuracy_period_start], "%.6f" % macd.macd_divergence_points[:divergence_points][-1])
    assert_equal("%.6f" % macd.macd_divergence_points[:divergence_points][-@accuracy_period_start-1], "%.6f" % macd.macd_divergence_points[:divergence_points][-2])
    assert_equal("%.6f" % macd.macd_divergence_points[:divergence_points][-@accuracy_period_start-2], "%.6f" % macd.macd_divergence_points[:divergence_points][-3])
  end

  def test_stochastic_should_return_valid_and_correct_slow_and_fast_stochastic_points
    stochastic = SignalTools.stochastic(@ticker, @period)
    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start], "%.6f" % stochastic.slow_stochastic[0][-1])
    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start-1], "%.6f" % stochastic.slow_stochastic[0][-2])
    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start-2], "%.6f" % stochastic.slow_stochastic[0][-3])
    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start], "%.6f" % stochastic.fast_stochastic[0][-1])
    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start-1], "%.6f" % stochastic.fast_stochastic[0][-2])
    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start-2], "%.6f" % stochastic.fast_stochastic[0][-3])
  end

  private

  def setup_historical_data(ticker, period)
    historical_data = {}
    hd = HistoricalData.new(ticker, period)
    hd.high_prices = [7.0, 8.0, 9.0] * (period + SignalTools::Extra_Days)
    hd.low_prices = [1.0, 2.0, 3.0] * (period + SignalTools::Extra_Days)
    hd.close_prices = [4.0, 5.0, 6.0] * (period + SignalTools::Extra_Days)
    hd.date_prices = {:some_date => 1}
    historical_data[SignalTools.cache_symbol([ticker, period])] = hd
    SignalTools.instance_variable_set('@historical_data_cache', historical_data)
  end
end
