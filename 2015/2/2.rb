# input = File.read("example_input").strip
input = File.read("input").strip

# Part 1
total = 0
input.each_line do |line|
  l, w, h = line.split("x").map(&:to_i)

  area = (2 * l * w) + (2 * w * h) + (2 * h * l)
  slack = [l, w, h].sort.first(2).reduce(:*)

  total += area + slack
end

puts "Part 1: #{total}"

# Part 2
ribbon = 0

input.each_line do |line|
  l, w, h = line.split("x").map(&:to_i)

  shortest_side = [l, w, h].sort.first(2)
  ribbon += (shortest_side * 2).flatten.sum

  ribbon += l * w * h
end

puts "Part 2: #{ribbon}"
