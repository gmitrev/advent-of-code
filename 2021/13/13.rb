require "set"

verbose = ENV["VERBOSE"]

dots, folds = File.read("input").split("\n\n")

dots = Set.new(dots.each_line.map(&:strip).map { |d| d.split(",").map(&:to_i) })
folds = folds.each_line.map { |fold| fold.scan(/(x|y)=(\d+)/).first }

def print_board(dots)
  max_x = dots.map(&:first).max + 1
  max_y = dots.map(&:last).max + 1

  max_y.times do |y|
    max_x.times do |x|
      if dots.include?([x, y])
        print "█"
      else
        print " "
      end
    end
    puts
  end
end

print_board(dots) if verbose

folds.each do |axis, line|
  case axis
  when "y"
    affected = dots.select { |x, y| y > line.to_i }

    affected.each do |x, y|
      dots << [x, line.to_i * 2 - y]
    end

    dots.subtract(affected)
  when "x"
    affected = dots.select { |x, y| x > line.to_i }

    affected.each do |x, y|
      dots << [line.to_i * 2 - x, y]
    end

    dots.subtract(affected)
  end

  print_board(dots) if verbose
end

puts "Part 1: #{dots.count}"
puts "Part 2:"
print_board(dots)
