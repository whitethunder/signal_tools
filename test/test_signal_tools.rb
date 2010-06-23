require 'test_helper'
require 'signal_tools'

class TestSignalTools < Test::Unit::TestCase

  def setup
  end

  def test_cache_symbol
    symbol = SignalTools.cache_symbol('wtf', 'omg', 'lol', '1337')
    assert_equal(:wtf_omg_lol_1337, symbol)
  end
end
