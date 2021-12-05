# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip.each_line.map(&:strip)

containers = input.map(&:to_i)

combinations = []

count = ->(sum, containers, path = []) {
  return if containers.empty?

  if sum == containers[0]
    combinations << path + [containers[0]]
  end

  count.call(sum - containers[0], containers[1..], path + [containers[0]])
  count.call(sum, containers[1..], path)
}

count.call(150, containers)

min = combinations.map(&:count).min
part2 = combinations.count { |p| p.size == min }

puts "Part 1: #{combinations.count}"
puts "Part 2: #{part2}"
