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
    assert((["%.6f" % macd[-1], "%.6f" % macd[-6]] - ["-0.229688"]).empty?)
    assert((["%.6f" % macd[-2], "%.6f" % macd[-7]] - ["-0.039898"]).empty?)
    assert((["%.6f" % macd[-3], "%.6f" % macd[-8]] - ["0.091403"]).empty?)
    assert((["%.6f" % macd[-4], "%.6f" % macd[-9]] - ["0.133413"]).empty?)
    assert((["%.6f" % macd[-5], "%.6f" % macd[-10]] - ["0.044770"]).empty?)

    assert((["%.6f" % divergence[-1], "%.6f" % divergence[-6]] - ["-0.195043"]).empty?)
    assert((["%.6f" % divergence[-2], "%.6f" % divergence[-7]] - ["-0.054013"]).empty?)
    assert((["%.6f" % divergence[-3], "%.6f" % divergence[-8]] - ["0.063784"]).empty?)
    assert((["%.6f" % divergence[-4], "%.6f" % divergence[-9]] - ["0.121740"]).empty?)
    assert((["%.6f" % divergence[-5], "%.6f" % divergence[-10]] - ["0.063532"]).empty?)
  end
end
