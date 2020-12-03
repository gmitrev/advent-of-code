numbers = File.read('input').each_line.map(&:to_i).sort

# Part 1
small, big = numbers.each_slice(numbers.count/2).to_a

needed = big.map { |b| [b, 2020 - b] }.to_h

needed.each do |k, v|
  puts "[Part 1] Result: #{k} * #{v} = #{k * v}" if small.index v
end

# Part 2
needed = numbers.map { |n| [n, 2020 - n] }.to_h

needed.each do |k, v|
  nested_numbers = numbers.map { |b| [b, v - b] }.to_h

  nested_numbers.each do |k1, v1|
    puts "[Part 2] Result: #{k} * #{k1} * #{v1} = #{k * k1 * v1}" if numbers.index v1
  end
end
