require 'test_helper'
require 'signal_tools'

class TestCommon < Test::Unit::TestCase
  def setup
    @ticker = "TESTING"
    @historical_data = get_historical_data
    @data = [1,2,3,4,5,6,7,8,9,10]
    @common = Common.new(@ticker, @historical_data)
    @period = 14
  end

  def test_common_should_return_valid_common_object
    assert(@common.ticker)
    assert(@common.high_prices)
    assert(@common.low_prices)
    assert(@common.close_prices)
    assert(@common.dates)
  end

  def test_ema_points_should_return_accurate_ema_values
    emas = @common.get_ema_points(@period, @common.close_prices)
    assert((["%.6f" % emas[-1], "%.6f" % emas[-6]] - ["2.444677"]).empty?)
    assert((["%.6f" % emas[-2], "%.6f" % emas[-7]] - ["2.682319"]).empty?)
    assert((["%.6f" % emas[-3], "%.6f" % emas[-8]] - ["2.818061"]).empty?)
    assert((["%.6f" % emas[-4], "%.6f" % emas[-9]] - ["2.836224"]).empty?)
    assert((["%.6f" % emas[-5], "%.6f" % emas[-10]] - ["2.718720"]).empty?)
  end

  def test_get_default_simple_average_should_return_accurate_simple_averages
    average = @common.get_default_simple_average(@data, @data.size)
    assert_equal(5.5, average)
    average = @common.get_default_simple_average(@data, 0)
    assert_nil(average)
  end

  def test_calculate_ema_should_return_correct_ema_value
    ema = @common.calculate_ema(4.56, 1.23, @period)
    assert_equal(4.116, ema)
  end

  def test_get_for_period_returns
    result = @common.get_for_period(@data, 1, 8, :max)
    assert_equal(9, result)
    result = @common.get_for_period(@data, 1, 8, :min)
    assert_equal(2, result)
  end

  def test_get_collection_for_array_returns_the_correct_collection
    result = @common.get_collection_for_array(@data, 9, :max)
    assert_equal([9,10], result)
    result = @common.get_collection_for_array(@data, 7, :average)
    assert_equal([4,5,6,7], result)
  end

  def test_true_range_returns_correct_true_range
    tr = @common.true_range(@historical_data[1], @historical_data[0])
    assert_equal(6.6, tr)
    tr = @common.true_range(@historical_data[5], @historical_data[4])
    assert_equal(1.3, tr)
  end

  def test_get_sum_emas_returns_correct_true_ranges
    true_ranges = @common.get_period_sum_ema(@period, @common.get_true_ranges(@historical_data))
    strings = true_ranges[-10..-1].map { |tr| "%.6f" % tr }
    assert_equal(["48.144747", "48.705836", "48.226848", "46.782073", "44.740496", "48.144747", "48.705836", "48.226848", "46.782073", "44.740496"], strings)
  end

  def test_get_true_ranges_returns_a_collection_of_correct_true_ranges
    true_ranges = @common.get_true_ranges(@historical_data)
    assert_equal([1.0, 6.6, 4.0, 3.0, 2.0, 1.3, 6.6, 4.0, 3.0, 2.0], true_ranges[0..9])
  end

  def test_caculate_average_true_range_returns_correct_true_range_value
    yesterday_tr = 5.5
    today_tr = 3.2
    true_range = @common.calculate_average_true_range(yesterday_tr, today_tr, @period)
    assert_equal("5.335714", "%.6f" % true_range)
  end

  def test_average_true_ranges_returns_a_collection_of_correct_average_true_ranges
    atrs = @common.average_true_ranges(@period, @historical_data)
    assert_equal("3.195750", "%.6f" % atrs.last)
  end
end
