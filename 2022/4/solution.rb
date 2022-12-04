input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

ranges = input.map do |line|
  line.split(",").flat_map { |l| l.split("-") }.map(&:to_i)
end

part1 = ranges.sum do |l1, l2, r1, r2|
  (l1..l2).cover?(r1..r2) || (r1..r2).cover?(l1..l2) ? 1 : 0
end

puts "Part 1: #{part1}"

part2 = ranges.sum do |l1, l2, r1, r2|
  ((l1..l2).to_a & (r1..r2).to_a).any? ? 1 : 0
end

puts "Part 2: #{part2}"
