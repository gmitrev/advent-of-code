# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip.each_line.map(&:strip)

# Part 1
distances = input.map do |f|
  speed, time, rest = f.scan(/\d+/).map(&:to_i)

  ([speed] * time + [0] * rest).cycle.take(2503).sum
end

puts "Part 1: #{distances.max}"

# Part 2
state = {}

input.map do |f|
  deer = f.split(" ").first
  speed, time, rest = f.scan(/\d+/).map(&:to_i)

  map = ([speed] * time + [0] * rest).cycle.take(2503)

  state[deer] = {
    map: map,
    distance: 0,
    points: 0
  }
end

# deerS!?!?!?!?
deers = state.keys.uniq

max_distance = 0

2503.times do |second|
  deers.each do |deer_name|
    deer = state[deer_name]

    deer[:distance] += deer[:map][second]

    max_distance = [max_distance, deer[:distance]].max
  end

  state.select do |deer_name, deer_data|
    deer_data[:distance] == max_distance
  end.each do |deer_name, _|
    state[deer_name][:points] += 1
  end
end

puts "Part 2: #{state.values.map { |v| v[:points] }.max}"
