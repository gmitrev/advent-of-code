require 'set'

input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).map { |l| l.split('') }
width = input.size
height = input[0].size

start = nil

input.each_with_index do |row, x|
  row.each_with_index do |col, y|
    start = [x, y, 0] if col == 'S'
  end
  break if start
end

queue = [start]
visited = Set.new

def connected?(pipe, position)
  case position
  when :north then %w(| 7 F).include?(pipe)
  when :east  then %w(- J 7).include?(pipe)
  when :south then %w(| L J).include?(pipe)
  when :west  then %w(- L F).include?(pipe)
  end
end

max_distance = 0

until queue.empty?
  current = queue.shift
  x, y, distance = current
  max_distance = [distance, max_distance].max

  neighbours = [
    [x - 1, y, :north],
    [x, y + 1, :east],
    [x + 1, y, :south],
    [x, y - 1, :west]
  ]

  neighbours.each do |a, b, position|
    next unless a >= 0 && b >= 0 && a < width && b < height

    if connected?(input[a][b], position) && !visited.include?([a,b])
      visited << [a, b]
      queue << [a, b, distance + 1]
    end
  end
end

puts "Part 1: #{max_distance}"
