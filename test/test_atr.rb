require 'test_helper'
require 'signal_tools'

class TestAtr < Test::Unit::TestCase
  def setup
    @ticker = "TESTING"
    @days = 30
    @period = 14
    @start_date = Date.today - @days - 10
    @end_date = Date.today - 10
  end

  def test_atr_should_return_consistent_atrs_to_given_precision
    atrs = ATR.new(@ticker, @period, get_historical_data).atrs
    assert((["%.6f" % atrs[-1], "%.6f" % atrs[-6]] - ["3.195750"]).empty?)
    assert((["%.6f" % atrs[-2], "%.6f" % atrs[-7]] - ["3.341577"]).empty?)
    assert((["%.6f" % atrs[-3], "%.6f" % atrs[-8]] - ["3.444775"]).empty?)
    assert((["%.6f" % atrs[-4], "%.6f" % atrs[-9]] - ["3.478988"]).empty?)
    assert((["%.6f" % atrs[-5], "%.6f" % atrs[-10]] - ["3.438910"]).empty?)

    atrs = ATR.new(@ticker, 15, get_historical_data).atrs
    assert((["%.6f" % atrs[-1], "%.6f" % atrs[-6]] - ["3.208282"]).empty?)
    assert((["%.6f" % atrs[-2], "%.6f" % atrs[-7]] - ["3.344588"]).empty?)
    assert((["%.6f" % atrs[-3], "%.6f" % atrs[-8]] - ["3.440630"]).empty?)
    assert((["%.6f" % atrs[-4], "%.6f" % atrs[-9]] - ["3.472103"]).empty?)
    assert((["%.6f" % atrs[-5], "%.6f" % atrs[-10]] - ["3.434397"]).empty?)
  end
end
