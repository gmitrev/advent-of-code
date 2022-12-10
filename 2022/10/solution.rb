input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).map { _1.split(" ") }

x = 1
cycles = []
cycles << x

input.each do |instruction, arg|
  if instruction == "noop"
    cycles << x
  elsif instruction == "addx"
    cycles << x
    cycles << x
    x += arg.to_i
  end
end

part1 = [20, 60, 100, 140, 180, 220].sum do |cycle|
  cycle * cycles[cycle]
end

puts "Part 1: #{part1}"

x = 1
cycle = 0
pixels = []

draw = ->(sprite) do
  pixels << (sprite.include?(cycle % 40) ? "#" : ".")
  cycle += 1
end

input.each do |instruction, arg|
  sprite = [x-1, x, x+1]

  if instruction == "noop"
    draw.call(sprite)
  elsif instruction == "addx"
    draw.call(sprite)
    draw.call(sprite)
    x += arg.to_i
  end
end

puts "Part 2:"
pixels.each_slice(40).each do |g|
  g.each { print _1 }
  puts
end
