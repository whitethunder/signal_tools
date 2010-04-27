require 'test_helper'
require 'signal_tools'

class SignalToolsTest < Test::Unit::TestCase

  def setup
    @ticker = "TESTING"
    @origin_date = '2000-01-01'
    @start_date = '2000-04-01'
    days = (Date.parse(@start_date) - Date.parse(@origin_date)).to_i
    setup_historical_data(@ticker, days, @start_date)
    # Get number of trading days in period. Find first three days that should be
    # accurate to 6 decimals, then compare with the last 3 days since we are repeating
    # 3 numbers in historical data.
    @accuracy_period_start = (days - (days / 7) * 2)
    @accuracy_period_start += case (@accuracy_period_start % 3)
      when 0 : 1
      when 1 : 0
      when 2 : 2
    end
  end

  def test_ema_should_return_valid_correct_emas
    ema = SignalTools.ema(@ticker, @start_date)
    assert_equal("%.6f" % ema.emas[-@accuracy_period_start], "%.6f" % ema.emas[-1])
    assert_equal("%.6f" % ema.emas[-@accuracy_period_start-1], "%.6f" % ema.emas[-2])
    assert_equal("%.6f" % ema.emas[-@accuracy_period_start-2], "%.6f" % ema.emas[-3])
  end

  def test_macd_should_return_valid_and_correct_macd_and_divergence_points
    macd = SignalTools.macd(@ticker, @start_date)
    assert_equal("%.6f" % macd.macd_divergence_points[:macd_points][-@accuracy_period_start], "%.6f" % macd.macd_divergence_points[:macd_points][-1])
    assert_equal("%.6f" % macd.macd_divergence_points[:macd_points][-@accuracy_period_start-1], "%.6f" % macd.macd_divergence_points[:macd_points][-2])
    assert_equal("%.6f" % macd.macd_divergence_points[:macd_points][-@accuracy_period_start-2], "%.6f" % macd.macd_divergence_points[:macd_points][-3])
    assert_equal("%.6f" % macd.macd_divergence_points[:divergence_points][-@accuracy_period_start], "%.6f" % macd.macd_divergence_points[:divergence_points][-1])
    assert_equal("%.6f" % macd.macd_divergence_points[:divergence_points][-@accuracy_period_start-1], "%.6f" % macd.macd_divergence_points[:divergence_points][-2])
    assert_equal("%.6f" % macd.macd_divergence_points[:divergence_points][-@accuracy_period_start-2], "%.6f" % macd.macd_divergence_points[:divergence_points][-3])
  end

  def test_stochastic_should_return_valid_and_correct_slow_and_fast_stochastic_points
    stochastic = SignalTools.stochastic(@ticker, @start_date)
    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start], "%.6f" % stochastic.slow_stochastic[0][-1])
    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start-1], "%.6f" % stochastic.slow_stochastic[0][-2])
    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start-2], "%.6f" % stochastic.slow_stochastic[0][-3])
    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start], "%.6f" % stochastic.fast_stochastic[0][-1])
    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start-1], "%.6f" % stochastic.fast_stochastic[0][-2])
    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start-2], "%.6f" % stochastic.fast_stochastic[0][-3])
  end

  def test_average_true_range_should_return_valid_and_correct_average_true_ranges
    atr = SignalTools.average_true_range(@ticker, @start_date)
    flunk "not complete"
  end

  private

  def setup_historical_data(ticker, days, start_date)
    historical_data = {}
    hd = HistoricalData.new(ticker, start_date)
    hd.high_prices = [9.3, 8.1, 7.6] * (days + HistoricalData::Extra_Days)
    hd.low_prices = [1.2, 2.4, 3.8] * (days + HistoricalData::Extra_Days)
    hd.close_prices = [4.5, 5.7, 6.9] * (days + HistoricalData::Extra_Days)
    hd.date_prices = {}
    today = Date.parse('2000-01-01')
    (0...(hd.high_prices.size)).each { |i| hd.date_prices[(today + i).strftime] = [ hd.high_prices[i], hd.low_prices[i], hd.close_prices[i] ] }
    historical_data[SignalTools.cache_symbol([ticker, start_date])] = hd
    SignalTools.instance_variable_set('@historical_data_cache', historical_data)
  end
end
