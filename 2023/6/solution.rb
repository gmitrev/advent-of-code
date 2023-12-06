input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

times = input[0].scan(/\d+/).map(&:to_i)
dists = input[1].scan(/\d+/).map(&:to_i)

races = times.zip(dists)

part1 = races.map do |time, to_beat|
  (0..time).count do |speed|
    ((time - speed) * speed) > to_beat
  end
end.reduce(:*)

puts "Part 1: #{part1}"

time = times.map(&:to_s).join.to_i
to_beat = dists.map(&:to_s).join.to_i

part2 = (0..time).count do |speed|
  ((time - speed) * speed) > to_beat
end

puts "Part 2: #{part2}"
