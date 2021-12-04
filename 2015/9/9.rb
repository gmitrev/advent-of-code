require "set"

# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip.each_line.map(&:strip)

edges = {}
locations = Set.new

input.each do |line|
  from, _, to, distance = line.scan(/\w+/)

  locations << from << to

  key = [from, to].sort
  edges[key] = distance.to_i
end

routes = locations.to_a.permutation.map do |route|
  distance = 0

  route.each_cons(2) do |from, to|
    key = [from, to].sort
    distance += edges[key]
  end

  distance
end

puts "Part 1: #{routes.min}"
puts "Part 2: #{routes.max}"
