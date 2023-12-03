require "set"

input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

numbers = []
stars = []
map = input.map(&:chars)

NUM = {num: "", y: nil, start: nil, end: nil}
ROWS = map.length - 1
COLS = map[0].length - 1

input.each_with_index do |row, y|
  current = NUM.dup

  row.chars.each_with_index do |col, x|
    if /\d/.match?(col)
      current[:num] += col
      current[:y] = y
      current[:start] ||= x
      current[:end] = x

      # FUCK THIS
      numbers << current if x == COLS
    elsif !current[:num].empty?
      numbers << current
      current = NUM.dup
    end

    if col == "*"
      stars << {num: "", y: y, start: x, end: x}
    end
  end
end

def find_edges(number)
  res = []
  ((number[:y] - 1)..(number[:y] + 1)).each do |y|
    next if y < 0 || y > ROWS

    ((number[:start] - 1)..(number[:end] + 1)).each do |x|
      next if x < 0 || x > COLS

      res << [y, x]
    end
  end

  except = (number[:start]..number[:end]).map { |a| [number[:y], a] }

  res - except
end

part1 = numbers.sum do |n|
  edges = find_edges(n)

  (edges.any? do |a, b|
    edge = map[a][b]
    edge && !(edge =~ /\d/) && edge != "."
  end) ? n[:num].to_i : 0
end

puts "Part 1: #{part1}"

part2 = stars.filter_map do |star|
  edges = find_edges(star)

  adjecent = Set.new
  edges.each do |a, b|
    if /\d/.match?(map[a][b])
      adjecent_number = numbers.find do |number|
        number[:y] == a && (number[:start]..number[:end]).cover?(b)
      end

      adjecent << adjecent_number if adjecent_number
    end
  end

  (adjecent.size == 2) ? adjecent.map { |a| a[:num].to_i }.reduce(:*) : nil
end.sum

puts "Part 2: #{part2}"
