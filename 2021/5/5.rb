require "set"

# input = File.read("example_input").each_line.map(&:strip)
input = File.read("input").each_line.map(&:strip)

# Part 1
map = Array.new(999) { Array.new(999, 0) }

input.each do |line|
  x1, y1, x2, y2 = line.scan(/\d+/).map(&:to_i)

  if x1 == x2
    y_start, y_end = [y1, y2].sort

    (y_start..y_end).each do |y|
      map[x1][y] += 1
    end
  elsif y1 == y2
    x_start, x_end = [x1, x2].sort

    (x_start..x_end).each do |x|
      map[x][y1] += 1
    end
  end
end

# map.transpose.each do |line|
#   line.each do |char|
#     print char == 0 ? "." : char
#   end
#   puts
# end

overlaps = map.flatten.count { |a| a > 1 }
puts "Part 1: #{overlaps}"

# Part 2
map = Array.new(999) { Array.new(999, 0) }

input.each do |line|
  x1, y1, x2, y2 = line.scan(/\d+/).map(&:to_i)

  if x1 == x2
    y_start, y_end = [y1, y2].sort

    (y_start..y_end).each do |y|
      map[x1][y] += 1
    end
  elsif y1 == y2
    x_start, x_end = [x1, x2].sort

    (x_start..x_end).each do |x|
      map[x][y1] += 1
    end
  else
    xs = x1 > x2 ? x1.downto(x2) : x1.upto(x2)
    ys = y1 > y2 ? y1.downto(y2) : y1.upto(y2)

    xs.zip(ys).each do |x, y|
      map[x][y] += 1
    end
  end
end

# map.transpose.each do |line|
#   line.each do |char|
#     print char == 0 ? "." : char
#   end
#   puts
# end

overlaps = map.flatten.count { |a| a > 1 }
puts "Part 2: #{overlaps}"
