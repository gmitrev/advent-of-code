require "set"

input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).map { |l| l.split(" ").map(&:to_i) }

valid = input.count do |line|
  a, b, c = line

  a + b > c && a + c > b && b + c > a
end

puts "Part 1: #{valid}"

input = input.reduce(&:zip).flatten.each_slice(3).to_a

valid = input.count do |line|
  a, b, c = line

  a + b > c && a + c > b && b + c > a
end

puts "Part 2: #{valid}"
