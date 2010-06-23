require 'test_helper'
require 'signal_tools'

class TestMacd < Test::Unit::TestCase
  def setup
    @ticker = "TESTING"
    @fast = 8
    @slow = 17
    @signal = 9
  end

  def test_macd_should_return_consistent_macds_and_divergence_points_to_given_precision
    macd_data = MACD.new(@ticker, @fast, @slow, @signal, get_historical_data)
    macd = macd_data.macd
    divergence = macd_data.divergence
    assert((["%.6f" % macd[-1], "%.6f" % macd[-6]] - ["-0.034645"]).empty?)
    assert((["%.6f" % macd[-2], "%.6f" % macd[-7]] - ["0.014116"]).empty?)
    assert((["%.6f" % macd[-3], "%.6f" % macd[-8]] - ["0.027619"]).empty?)
    assert((["%.6f" % macd[-4], "%.6f" % macd[-9]] - ["0.011673"]).empty?)
    assert((["%.6f" % macd[-5], "%.6f" % macd[-10]] - ["-0.018762"]).empty?)

    assert((["%.6f" % divergence[-1], "%.6f" % divergence[-6]] - ["-0.195043"]).empty?)
    assert((["%.6f" % divergence[-2], "%.6f" % divergence[-7]] - ["-0.054013"]).empty?)
    assert((["%.6f" % divergence[-3], "%.6f" % divergence[-8]] - ["0.063784"]).empty?)
    assert((["%.6f" % divergence[-4], "%.6f" % divergence[-9]] - ["0.121740"]).empty?)
    assert((["%.6f" % divergence[-5], "%.6f" % divergence[-10]] - ["0.063532"]).empty?)

    macd_data = MACD.new(@ticker, 12, 26, 9, get_historical_data)
    macd = macd_data.macd
    divergence = macd_data.divergence
    assert((["%.6f" % macd[-1], "%.6f" % macd[-6]] - ["-0.022654"]).empty?)
    assert((["%.6f" % macd[-2], "%.6f" % macd[-7]] - ["0.011419"]).empty?)
    assert((["%.6f" % macd[-3], "%.6f" % macd[-8]] - ["0.018934"]).empty?)
    assert((["%.6f" % macd[-4], "%.6f" % macd[-9]] - ["0.006399"]).empty?)
    assert((["%.6f" % macd[-5], "%.6f" % macd[-10]] - ["-0.014099"]).empty?)

    assert((["%.6f" % divergence[-1], "%.6f" % divergence[-6]] - ["-0.136291"]).empty?)
    assert((["%.6f" % divergence[-2], "%.6f" % divergence[-7]] - ["-0.030059"]).empty?)
    assert((["%.6f" % divergence[-3], "%.6f" % divergence[-8]] - ["0.050141"]).empty?)
    assert((["%.6f" % divergence[-4], "%.6f" % divergence[-9]] - ["0.081991"]).empty?)
    assert((["%.6f" % divergence[-5], "%.6f" % divergence[-10]] - ["0.034219"]).empty?)
  end
end
