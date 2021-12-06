# input = File.read("example_input").each_line.map(&:strip)
input = File.read("input").each_line.map(&:strip)

fish = input.first.split(",").map(&:to_i)

cache = {}
rem = ->(days, start) do
  return cache[[days, start]] if cache[[days, start]]

  kor = days - start - 1

  children = []
  k = days - start
  while k > 0
    children << k
    k -= 7
  end

  children_sum = children.sum { |c| rem.call(c, 9) }
  res = kor / 7 + 1 + children_sum
  res = res < 0 ? 0 : res
  cache[[days, start]] = res
  res
end

part1 = {}
days = 80
(1..5).each do |day|
  part1[day] = rem.call(days, day) + 1
end

puts "Part 1:" + fish.map { |f| part1[f] }.sum.to_s

part2 = {}
days = 256
(1..5).each do |day|
  part2[day] = rem.call(days, day) + 1
end

puts "Part 2:" + fish.map { |f| part2[f] }.sum.to_s
