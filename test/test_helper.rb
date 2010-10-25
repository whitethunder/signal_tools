require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'signal_tools'

class Test::Unit::TestCase
  def data_for_tests(period)
    repeat = 5
    historical_data = []
    (0...SignalTools::StockData::Extra_Days+period).each do |i|
      seed = i % repeat + 1
      historical_data << [
        (Date.today-i).to_s,
        (seed * 0.8).to_s, #Open
        (seed * 1.5).to_s, #High
        (seed * 0.5).to_s, #Low
        (seed * 0.9).to_s  #Close
      ]
    end
    historical_data
  end
end
