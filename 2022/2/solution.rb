input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).map do |line|
  a, b = line.split(" ")
  [a, (b.ord - 23).chr]
end

rules = {
  "A" => {points: 1, beats: "C", loses: "B"},
  "B" => {points: 2, beats: "A", loses: "C"},
  "C" => {points: 3, beats: "B", loses: "A"}
}

points = ->(a, b) do
  return 3 if a == b
  return 0 if rules[a][:beats] == b
  6
end

part1 = input.sum do |a, b|
  points.call(a, b) + rules[b][:points]
end

puts "Part 1: #{part1}"

part2 = input.sum do |a, b|
  b =
    case b
    when "A" then rules[a][:beats]
    when "B" then a
    when "C" then rules[a][:loses]
    end

  points.call(a, b) + rules[b][:points]
end

puts "Part 2: #{part2}"
