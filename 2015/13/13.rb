# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip.each_line.map(&:strip)

input.map { |i| i.split(" ") }.first.size

map = {}

input.each do |line|
  a, *rest, b = line.delete(".").split(" ")

  change = rest[1] == "gain" ? rest[2].to_i : -rest[2].to_i

  map[a] ||= {}
  map[a][b] = change
end

people = map.keys.flatten.uniq

variations = people.permutation.map do |neighbors|
  happiness = 0

  neighbors.each_cons(2) do |a, b|
    happiness += map[a][b]
    happiness += map[b][a]
  end

  a, *, b = neighbors

  happiness += map[a][b]
  happiness += map[b][a]

  happiness
end

puts "Part 1: #{variations.max}"

map = {}

input.each do |line|
  a, *rest, b = line.delete(".").split(" ")

  change = rest[1] == "gain" ? rest[2].to_i : -rest[2].to_i

  map[a] ||= {}
  map[a][b] = change
end

people = map.keys.flatten.uniq

map["Georgi"] = {}
people.each do |person|
  map[person]["Georgi"] = 0
  map["Georgi"][person] = 0
end

people = map.keys.flatten.uniq

variations = people.permutation.map do |neighbors|
  happiness = 0

  neighbors.each_cons(2) do |a, b|
    happiness += map[a][b]
    happiness += map[b][a]
  end

  a, *, b = neighbors

  happiness += map[a][b]
  happiness += map[b][a]

  happiness
end

puts "Part 2: #{variations.max}"
