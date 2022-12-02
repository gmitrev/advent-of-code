input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

print "Part 1: "
puts input.slice_before { |el| el == "" }.map { _1.map(&:to_i).sum }.max

print "Part 2: "
puts input.slice_before { |el| el == "" }.map { _1.map(&:to_i).sum }.max(3).sum
