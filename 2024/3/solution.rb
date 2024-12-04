input_file = ENV["TEST"] ? "example_input" : "input"
# while true; do ruby solution.rb; sleep 0.3; done

input = File.read(input_file).chomp

commands = input.scan(/(mul\(\d+\,\d+\))/).flatten
part1 =  commands.map { |c| c.scan(/\d+/).map(&:to_i).reduce(:*) }.sum

puts "Part 1: #{part1}"

commands2 = input.scan(/(don\'t\(\))|(do\(\))|(mul\(\d+\,\d+\))/).flatten.compact

disabled = false

DO = "do()"
DONT = "don't()"

part2 = commands2.sum do |command|
  if [DO, DONT].include?(command)
    disabled = command == DONT

    next 0
  end

  disabled ? 0 : command.scan(/\d+/).map(&:to_i).reduce(:*)
end

puts "Part 2: #{part2}"
