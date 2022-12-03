input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

part1 = input.sum do |line|
  a, b = line.chars.each_slice(line.size / 2).to_a

  char = (a & b).first.ord

  (char > 90) ? char - 96 : char - 38
end

puts "Part 1: #{part1}"

part2 = input.each_slice(3).sum do |group|
  char = group.reduce(("A".."z").to_a) { |mem, a| mem & a.chars }.first.ord

  (char > 90) ? char - 96 : char - 38
end

puts "Part2: #{part2}"
