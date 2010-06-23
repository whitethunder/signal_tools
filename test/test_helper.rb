require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'signal_tools'

class Test::Unit::TestCase
  def get_historical_data(repeat=5)
    historical_data = []
    (SignalTools::Extra_Days).downto(0) do |i|
      seed = i % repeat + 1
      historical_data << [
        (Date.today-i).to_s,
        seed * 0.8, #Open
        seed * 1.5, #High
        seed * 0.5, #Low
        seed * 0.9  #Close
      ]
    end
    historical_data
  end
end
