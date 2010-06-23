require 'test_helper'
require 'signal_tools'

class TestEma < Test::Unit::TestCase
  def setup
    @ticker = "TESTING"
    @days = 30
    @period = 10
    @start_date = Date.today - @days - 10
    @end_date = Date.today - 10
  end

  def test_ema_should_return_consistent_emas_to_given_precision
    emas = EMA.new(@ticker, @period, get_historical_data).emas
    assert((["%.6f" % emas[-1], "%.6f" % emas[-6]] - ["2.344948"]).empty?)
    assert((["%.6f" % emas[-2], "%.6f" % emas[-7]] - ["2.666048"]).empty?)
    assert((["%.6f" % emas[-3], "%.6f" % emas[-8]] - ["2.858503"]).empty?)
    assert((["%.6f" % emas[-4], "%.6f" % emas[-9]] - ["2.893726"]).empty?)
    assert((["%.6f" % emas[-5], "%.6f" % emas[-10]] - ["2.736776"]).empty?)

    emas = EMA.new(@ticker, 25, get_historical_data).emas
    assert((["%.6f" % emas[-1], "%.6f" % emas[-6]] - ["2.556322"]).empty?)
    assert((["%.6f" % emas[-2], "%.6f" % emas[-7]] - ["2.694348"]).empty?)
    assert((["%.6f" % emas[-3], "%.6f" % emas[-8]] - ["2.768877"]).empty?)
    assert((["%.6f" % emas[-4], "%.6f" % emas[-9]] - ["2.774617"]).empty?)
    assert((["%.6f" % emas[-5], "%.6f" % emas[-10]] - ["2.705835"]).empty?)
  end
end
