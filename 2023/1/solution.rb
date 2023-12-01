input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

part1 = input.sum do |l|
  nums = l.scan(/\d/)

  (nums[0] + nums[-1]).to_i
end

puts "Part 1: #{part1}"

numbers = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}

numbers_regex = %r{^(#{numbers.keys.join("|")}|\d)}

part2 = input.sum do |line|
  nums = []

  while line.size > 0
    match = line.match(numbers_regex)
    nums << (numbers[match[0]] || match[0].to_i) if match
    line = line[1..]
  end

  "#{nums[0]}#{nums[-1]}".to_i
end

puts "Part 2: #{part2}"
