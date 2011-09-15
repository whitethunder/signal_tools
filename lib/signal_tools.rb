require "signal_tools/stock_data"
require "signal_tools/stock"

module SignalTools
  def self.sum(array)
    array.inject(0) {|accum, c| accum + c.to_f }
  end

  def self.average(array)
    return nil if !array || array.size == 0
    sum(array).to_f / array.size
  end

  # Truncates all arrays to the size of the shortest array by cutting off the front
  # of the longer arrays.
  def self.truncate_to_shortest!(*arrays)
    shortest_size = arrays.inject(arrays.first.size) { |size, array| array.size < size ? array.size : size }
    arrays.each { |array| array.slice!(0...(array.size - shortest_size)) }
  end
end
