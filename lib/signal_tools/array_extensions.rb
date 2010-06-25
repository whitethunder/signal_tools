class Array
  def sum
    self.inject(0) {|accum, c| accum + c.to_f }
  end

  def average(last = self.size)
    raise "Invalid parameter" if last < 0 || last > self.size
    return nil if self.size == 0
    a = self.slice((self.size - last)..(self.size - 1))
    a.sum.to_f / a.size
  end

  # Truncates all arrays to the size of the shortest array by cutting off the front
  # of the longer arrays.
  def self.truncate_to_shortest!(*arrays)
    shortest_size = arrays.inject(arrays.first.size) { |size, array| array.size < size ? array.size : size }
    arrays.each { |array| array.slice!(0...(array.size - shortest_size)) }
  end

#  def average_growth
#    total = 0.0
#    self.inject { |p, c|
#      total += ((c - p).to_f / p.to_f)
#      c
#    }
#    total / (self.size - 1).to_f
#  end

#  def median
#    return nil if self.size == 0
#    self.sort!
#    n = (self.length - 1) / 2
#    n2 = (self.length) / 2

#    if self.length % 2 == 0
#     (self[n] + self[n2]) / 2
#    else
#     self[n]
#    end
#  end

#  # Deletes all prior elements if the block is true
#  def delete_all_prior_if(&block)
#    result = []
#    self.each do |e|
#      if yield(e)
#        result = []
#      else
#        result << e
#      end
#    end
#    result
#  end
end
