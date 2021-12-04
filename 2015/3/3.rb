require "set"

# input = File.read("example_input").strip
input = File.read("input").strip

# Part 1
x = 0
y = 0

visited = Set.new

input.each_char do |c|
  case c
  when "^"
    y += 1
  when "v"
    y -= 1
  when ">"
    x += 1
  when "<"
    x -= 1
  end

  visited << [x, y]
end

puts "Part 1: #{visited.count}"

# Part 2
santa = {x: 0, y: 0}
robot = {x: 0, y: 0}
visited = Set.new

input.each_char.with_index do |c, i|
  current = i % 2 == 0 ? santa : robot

  case c
  when "^"
    current[:y] += 1
  when "v"
    current[:y] -= 1
  when ">"
    current[:x] += 1
  when "<"
    current[:x] -= 1
  end

  visited << [current[:x], current[:y]]
end

puts "Part 2: #{visited.count}"
