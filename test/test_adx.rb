require 'test_helper'
require 'signal_tools'

class TestAdx < Test::Unit::TestCase
  def setup
    @ticker = "TESTING"
    @days = 30
    @period = 14
    @start_date = Date.today - @days - 10
    @end_date = Date.today - 10
    @historical_data = get_historical_data
    @adx = ADX.new(@ticker, @period, @historical_data)
  end

  def test_up_move
    result = @adx.send(:get_up_move, @historical_data[-1], @historical_data[-2])
    assert_equal(0, result)
    result = @adx.send(:get_up_move, @historical_data[-5], @historical_data[-6])
    assert_equal(6, result)
  end

  def test_down_move
    result = @adx.send(:get_down_move, @historical_data[-1], @historical_data[-2])
    assert_equal(0.5, result)
    result = @adx.send(:get_down_move, @historical_data[-5], @historical_data[-6])
    assert_equal(0, result)
  end

  def test_get_plus_dm
    result = @adx.send(:get_plus_dm, @historical_data)
    assert_equal(0, result[-1])
    assert_equal(6, result[-5])
  end

  def test_get_minus_dm
    result = @adx.send(:get_minus_dm, @historical_data)
    assert_equal(0.5, result[-1])
    assert_equal(0, result[-5])
  end

  def test_get_plus_di
    results = @adx.send(:get_plus_di, @period, @historical_data)
    assert_equal("0.322001", "%.6f" % results[-1])
  end

  def test_get_minus_di
    results = @adx.send(:get_minus_di, @period, @historical_data)
    assert_equal("0.129624", "%.6f" % results[-1])
  end

  def test_get_dxs
    plus_dis = @adx.send(:get_plus_di, @period, @historical_data)
    minus_dis = @adx.send(:get_minus_di, @period, @historical_data)

    results = @adx.send(:get_dxs, plus_dis, minus_dis)
    assert_equal("0.425965", "%.6f" % results[-1])
    assert_equal("0.565054", "%.6f" % results[-5])
  end

  def test_adx_should_return_consistent_adxs_to_given_precision
    adxs = @adx.adxs
    assert_equal("0.491321", "%.6f" % adxs[-1])
    assert_equal("0.496588", "%.6f" % adxs[-5])
  end
end
