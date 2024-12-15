require_relative '../../common.rb'

input = read_input.split("\n\n")
d input

def workwork(ax, ay, bx, by, x, y)
  b = (ax * y - ay * x) / (ax * by - ay * bx)

  a = (y - by * b) / ay

  [a, b]
end


part1 = input.sum do |machine|
  ax, ay, bx, by, x, y =  machine.scan(/\d+/).map(&:to_f)

  a, b = workwork(ax, ay, bx, by, x, y)

  if a.to_i == a && b.to_i == b
    a * 3 + b
  else
    0
  end
end

solve(1, part1.to_i)

part2 = input.sum do |machine|
  ax, ay, bx, by, x, y =  machine.scan(/\d+/).map(&:to_f)

  a, b = workwork(ax, ay, bx, by, x + 10000000000000, y + 10000000000000)

  if a.to_i == a && b.to_i == b
    a * 3 + b
  else
    0
  end
end

solve(2, part2.to_i)
