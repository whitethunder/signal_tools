require 'test_helper'
require 'signal_tools'

class TestStochastic < Test::Unit::TestCase
  def setup
    @ticker = "TESTING"
    @k = 14
    @d = 5
  end

  def test_stochastic_should_return_valid_and_correct_slow_and_fast_stochastic_points
    stochastics = Stochastic.new(@ticker, @k, @d, get_historical_data)
    fast_stochastic = stochastics.fast
    slow_stochastic = stochastics.slow

    assert((["%.6f" % fast_stochastic[:k][-1], "%.6f" % fast_stochastic[:k][-6]] - ["0.057143"]).empty?)
    assert((["%.6f" % fast_stochastic[:d][-1], "%.6f" % fast_stochastic[:d][-6]] - ["0.314286"]).empty?)
    assert((["%.6f" % fast_stochastic[:k][-2], "%.6f" % fast_stochastic[:k][-7]] - ["0.185714"]).empty?)
    assert((["%.6f" % fast_stochastic[:d][-2], "%.6f" % fast_stochastic[:d][-7]] - ["0.314286"]).empty?)
    assert((["%.6f" % fast_stochastic[:k][-3], "%.6f" % fast_stochastic[:k][-8]] - ["0.314286"]).empty?)
    assert((["%.6f" % fast_stochastic[:d][-3], "%.6f" % fast_stochastic[:d][-8]] - ["0.314286"]).empty?)
    assert((["%.6f" % fast_stochastic[:k][-4], "%.6f" % fast_stochastic[:k][-9]] - ["0.442857"]).empty?)
    assert((["%.6f" % fast_stochastic[:d][-4], "%.6f" % fast_stochastic[:d][-9]] - ["0.314286"]).empty?)
    assert((["%.6f" % fast_stochastic[:k][-5], "%.6f" % fast_stochastic[:k][-10]] - ["0.571429"]).empty?)
    assert((["%.6f" % fast_stochastic[:d][-5], "%.6f" % fast_stochastic[:d][-10]] - ["0.314286"]).empty?)

    assert((["%.6f" % slow_stochastic[:k][-1], "%.6f" % slow_stochastic[:k][-6]] - ["0.185714"]).empty?)
    assert((["%.6f" % slow_stochastic[:d][-1], "%.6f" % slow_stochastic[:d][-6]] - ["0.314286"]).empty?)
    assert((["%.6f" % slow_stochastic[:k][-2], "%.6f" % slow_stochastic[:k][-7]] - ["0.314286"]).empty?)
    assert((["%.6f" % slow_stochastic[:d][-2], "%.6f" % slow_stochastic[:d][-7]] - ["0.314286"]).empty?)
    assert((["%.6f" % slow_stochastic[:k][-3], "%.6f" % slow_stochastic[:k][-8]] - ["0.442857"]).empty?)
    assert((["%.6f" % slow_stochastic[:d][-3], "%.6f" % slow_stochastic[:d][-8]] - ["0.314286"]).empty?)
    assert((["%.6f" % slow_stochastic[:k][-4], "%.6f" % slow_stochastic[:k][-9]] - ["0.357143"]).empty?)
    assert((["%.6f" % slow_stochastic[:d][-4], "%.6f" % slow_stochastic[:d][-9]] - ["0.314286"]).empty?)
    assert((["%.6f" % slow_stochastic[:k][-5], "%.6f" % slow_stochastic[:k][-10]] - ["0.271429"]).empty?)
    assert((["%.6f" % slow_stochastic[:d][-5], "%.6f" % slow_stochastic[:d][-10]] - ["0.314286"]).empty?)
  end
end
