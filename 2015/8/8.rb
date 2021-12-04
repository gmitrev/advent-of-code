# input = File.read("example_input").strip
input = File.read("input").strip
literals = 0
characters = 0

input.each_line.map(&:strip).each do |line|
  literals += eval(line).size
  characters += line.size
end

puts "Part 1: #{characters - literals}"

literals = 0
input.each_line.map(&:strip).each do |line|
  literals += line.inspect.size
end

puts "Part 2: #{literals - characters}"
