input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

part1 = input.map(&:chars).reduce(&:zip).map { |l| l.flatten.tally.max_by { |k, v| v } }.map(&:first).join

puts "Part 1: #{part1}"

part2 = input.map(&:chars).reduce(&:zip).map { |l| l.flatten.tally.min_by { |k, v| v } }.map(&:first).join

puts "Part 2: #{part2}"
