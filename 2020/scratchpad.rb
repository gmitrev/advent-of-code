# 1
numbers = File.read('1/input').each_line.map(&:to_i)

small, big = numbers.sort.each_slice(numbers.count/2).to_a

needed = big.map { |b| [b, 2020 - b] }.to_h

needed.each do |k, v|
  puts "Result: #{k} * #{v} = #{k * v}"if small.index v
end

#2
