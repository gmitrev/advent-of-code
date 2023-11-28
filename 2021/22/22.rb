require "set"

input = File.read("input").lines(chomp: true)

on = Set.new

input.each do |line|
  x1, x2, y1, y2, z1, z2 = line.scan(/-?\d+/).map(&:to_i)
  command, * = line.scan(/on|off/)

  within_bounds = (x1 >= -50 && x1 <= 50) && (y1 >= -50 && y2 <= 50) && (z1 >= -50 && z2 <= 50)

  next unless within_bounds

  (x1..x2).each do |x|
    (y1..y2).each do |y|
      (z1..z2).each do |z|
        if command == "on"
          on << [x, y, z]
        else
          on.subtract [[x, y, z]]
        end
      end
    end
  end
end

puts "Part 1: #{on.count}"
