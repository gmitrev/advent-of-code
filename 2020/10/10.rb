input = File.read('input').each_line.map { |l| l.strip.to_i }.sort

jolts = []

input.unshift 0
input.push input.max + 3

input.each_cons(2) do |a, b|
  jolts << b - a
end

ones = jolts.count(1)
threes = jolts.count(3)

puts "[Part 1]: #{ones} * #{threes} = #{ones * threes}"

numbers = input.map { |i| [i, []] }.to_h

numbers.each do |n, _|
  jolts = [n + 1, n + 2, n + 3] & numbers.keys

  numbers[n] << jolts.count
end

numbers.keys.reverse.each do |n, _|
  following = numbers.values_at(n+1, n+2, n+3).compact.map(&:last)
  numbers[n] << (following.empty? ? 1 : following.sum)
end

puts "[Part 2]: #{numbers[0].last}"
