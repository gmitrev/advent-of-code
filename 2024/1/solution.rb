input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

numbers = input.map(&:split)

first_col = numbers.map(&:first).map(&:to_i)
second_col = numbers.map(&:last).map(&:to_i)

part1 = first_col.sort.zip(second_col.sort).map { |a, b| (a-b).abs }.sum

puts "Part 1: #{part1}"

tally = second_col.tally

part2 = first_col.sum do |n|
  n * tally.fetch(n, 0)
end

puts "Part 2: #{part2}"
