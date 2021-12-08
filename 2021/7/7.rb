# input = File.read("example_input").each_line.map(&:strip)
input = File.read("input").each_line.map(&:strip)

crabs = input.first.split(",").map(&:to_i)

fuel = (crabs.min..crabs.max).map do |level|
  crabs.map { |crab| (crab - level).abs }.sum
end.min

puts "Part 1: #{fuel}"

fuel = (crabs.min..crabs.max).map do |level|
  crabs.map do |crab|
    diff = (crab - level).abs
    (diff * diff + diff) / 2
  end.sum
end.min

puts "Part 2: #{fuel}"
