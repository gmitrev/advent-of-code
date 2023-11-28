require "set"

input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)[0].split(", ")

def move(dir, x, y, steps)
  case dir
  when :n then y += steps
  when :e then x += steps
  when :s then y -= steps
  when :w then x -= steps
  end

  [x, y]
end

def find_direction(rotate, pos)
  dirs = %i[n e s w]
  index = dirs.index(pos) + ((rotate == "R") ? 1 : -1)
  index = 0 if index == 4
  index = 3 if index == -1

  dirs[index]
end

# Part 1

x = 0
y = 0
direction = :n

input.each do |instruction|
  rotate, *steps = instruction.chars
  steps = steps.join.to_i

  direction = find_direction(rotate, direction)

  x, y = move(direction, x, y, steps)
end

puts "[Part 1] #{x.abs + y.abs}"

# Part 2

x = 0
y = 0
direction = :n
visited = Set.new
finished = false

input.each do |instruction|
  break if finished
  rotate, *steps = instruction.chars
  steps = steps.join.to_i

  direction = find_direction(rotate, direction)

  steps.times do
    x, y = move(direction, x, y, 1)
    if visited.include?([x, y])
      finished = true
      break
    end
    visited << [x, y]
  end
end

puts "[Part 2] #{x.abs + y.abs}"
