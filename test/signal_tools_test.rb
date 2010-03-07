require 'test_helper'
require 'signal_tools'

class SignalToolsTest < Test::Unit::TestCase
  def setup
    @stochastic = Stochastic.new("TESTING", 90, false)
    @stochastic.high_prices = [7.0, 8.0, 9.0] * 30
    @stochastic.low_prices = [1.0, 2.0, 3.0] * 30
    @stochastic.close_prices = [4.0, 5.0, 6.0] * 30

    @macd = MACD.new("TESTING", 90, false)
    @macd.high_prices = [7.0, 8.0, 9.0] * 30
    @macd.low_prices = [1.0, 2.0, 3.0] * 30
    @macd.close_prices = [4.0, 5.0, 6.0] * 30
  end

  def test_sma_calculation
    sma = @st.send(:calculate_sma, @st.close_prices.slice(0..10))
    assert_equal(sma.to_s[0..5], "4.9090")
  end

#  def test_ema_calculation
#    setup_good_st_data
#    ema = @st.send(:calculate_ema, 8.0, 6.0, 4)
#    assert(ema, 6.8)
#  end

#  def test_get_price_for_period
#    setup_st_no_data
#    prices = [0.1, 54321, 1, 0.01, 0.001, 65432]
#    min = @st.send(:get_price_for_period, prices, 0, 3, :min)
#    assert(min, 0.01)
#    max = @st.send(:get_price_for_period, prices, 0, 4, :max)
#    assert(max, 54321)
#    average = @st.send(:get_price_for_period, prices, 1, 2, :average)
#    assert(average, 27161)
#  end
end
