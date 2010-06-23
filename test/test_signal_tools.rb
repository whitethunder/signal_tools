require 'test_helper'
require 'signal_tools'

class TestSignalTools < Test::Unit::TestCase

  def setup
#    @ticker = "TESTING"
#    @origin_date = Date.parse('2000-01-01')
#    @start_date = Date.parse('2000-07-01')
#    days = (@start_date - @origin_date).to_i
#    setup_historical_data(@ticker, days, @start_date.strftime)
  end

  def test_cache_symbol
    symbol = SignalTools.cache_symbol('wtf', 'omg', 'lol', '1337')
    assert_equal(:wtf_omg_lol_1337, symbol)
  end

#  def test_stochastic_should_return_valid_and_correct_slow_and_fast_stochastic_points
#    stochastic = SignalTools.stochastic(@ticker, @start_date.strftime)
#    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start], "%.6f" % stochastic.slow_stochastic[0][-1])
#    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start-1], "%.6f" % stochastic.slow_stochastic[0][-2])
#    assert_equal("%.6f" % stochastic.slow_stochastic[0][-@accuracy_period_start-2], "%.6f" % stochastic.slow_stochastic[0][-3])
#    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start], "%.6f" % stochastic.fast_stochastic[0][-1])
#    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start-1], "%.6f" % stochastic.fast_stochastic[0][-2])
#    assert_equal("%.6f" % stochastic.fast_stochastic[0][-@accuracy_period_start-2], "%.6f" % stochastic.fast_stochastic[0][-3])
#  end

#  def test_average_true_range_should_return_valid_and_correct_average_true_ranges
#    atr = SignalTools.average_true_range(@ticker, @start_date.strftime)
#    assert_equal("%.4f" % atr.average_true_range[@start_date.strftime],     "%.4f" % atr.average_true_range[(@start_date+9).strftime])
#    assert_equal("%.4f" % atr.average_true_range[(@start_date+1).strftime], "%.4f" % atr.average_true_range[(@start_date+10).strftime])
#    assert_equal("%.4f" % atr.average_true_range[(@start_date+2).strftime], "%.4f" % atr.average_true_range[(@start_date+11).strftime])
#  end

#  def test_average_directional_index_should_return_valid_and_correct_average_directional_points
#    adx = SignalTools.average_directional_index(@ticker, @start_date.strftime)
#    assert_equal("%.4f" % adx.average_directional_index[@start_date.strftime],     "%.4f" % adx.average_directional_index[(@start_date+9).strftime])
#    assert_equal("%.4f" % adx.average_directional_index[(@start_date+1).strftime], "%.4f" % adx.average_directional_index[(@start_date+10).strftime])
#    assert_equal("%.4f" % adx.average_directional_index[(@start_date+2).strftime], "%.4f" % adx.average_directional_index[(@start_date+11).strftime])
#  end

#  private

#  def setup_historical_data(ticker, days, start_date)
#    historical_data = {}
#    hd = HistoricalData.new(ticker, start_date)
#    hd.high_prices = [9.3, 8.1, 7.6] * (days + HistoricalData::Extra_Days)
#    hd.low_prices = [1.2, 2.4, 3.8] * (days + HistoricalData::Extra_Days)
#    hd.close_prices = [4.5, 5.7, 6.9] * (days + HistoricalData::Extra_Days)
#    hd.date_prices = {}
#    today = Date.parse('2000-01-01')
#    (0...(hd.high_prices.size)).each { |i| hd.date_prices[(today + i).strftime] = [ hd.high_prices[i], hd.low_prices[i], hd.close_prices[i] ] }
#    historical_data[SignalTools.cache_symbol([ticker, start_date])] = hd
#    SignalTools.instance_variable_set('@historical_data_cache', historical_data)
#  end
end
