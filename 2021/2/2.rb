# input = File.read("example_input").each_line
input = File.read("input").each_line

# Part 1
x = 0
z = 0

input.map { |l| l.split(" ") }.each do |command, steps|
  case command
  when "forward"
    x += steps.to_i
  when "down"
    z += steps.to_i
  when "up"
    z -= steps.to_i
  end
end

puts "Part 1: #{x * z}"

# Part 2
x = 0
z = 0
a = 0


input.map { |l| l.split(" ") }.each do |command, steps|
  case command
  when "forward"
    x += steps.to_i
    z += a * steps.to_i
  when "down"
    a += steps.to_i
  when "up"
    a -= steps.to_i
  end
end

puts "Part 1: #{x * z}"
