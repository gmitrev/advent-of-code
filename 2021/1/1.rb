numbers = File.read("input").each_line.map(&:to_i)

# Part 1
numbers.each_cons(2).count { |a, b| b > a }

# Part 2
numbers.each_cons(4).count { |a| a.last(3).sum > a.first(3).sum }
