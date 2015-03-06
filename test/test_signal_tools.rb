require './test/test_helper'

class TestSignalTools < Minitest::Test
  def setup
    @array1 = [1,2,3,4,5,6,7,8,9,10]
  end

  def test_sum_returns_the_correct_sum_of_array_elements
    assert_equal(55, SignalTools::sum(@array1))
  end

  def test_average_returns_the_correct_average_of_array_elements
    assert_equal(5.5, SignalTools::average(@array1))
  end

  def test_truncate_to_shortest_returns_two_arrays_of_equal_size
    array2 = [1,2,3]
    SignalTools::truncate_to_shortest!(@array1, array2)
    assert_equal(@array1.size, array2.size)
  end
end
