require "set"

input = File.read("input").each_line.map(&:strip).map(&:chars).map { |l| l.map(&:to_i) }

adjecent = [[-1, 0], [0, -1], [1, 0], [0, 1]]

rows = input.count
cols = input.first.count

risk = 0

rows.times do |y|
  cols.times do |x|
    neighbors = adjecent.map do |delta_x, delta_y|
      input[y + delta_y][x + delta_x] if delta_x + x >= 0 && delta_y + y >= 0 && delta_x + x < cols && delta_y + y < rows
    end.compact

    risk += input[y][x] + 1 if neighbors.all? { |n| n > input[y][x] }
  end
end

puts "Part 1: #{risk}"

# Part 2
basins = []
seen = Set.new

basin = ->(low_points, y, x) do
  seen << [y, x]

  neighbors = adjecent.map do |delta_x, delta_y|
    xx = delta_x + x
    yy = delta_y + y

    # Out of bounds
    next unless xx >= 0 && yy >= 0 && xx < cols && yy < rows

    neighbor = input[yy][xx]

    # Reached end of basin
    next if neighbor == 9

    # Already checked
    next if seen.member?([yy, xx])

    [yy, xx]
  end.compact

  ["#{y},#{x}"] + neighbors.map { |ny, nx| basin.call(low_points, ny, nx) }
end

rows.times do |y|
  cols.times do |x|
    neighbors = adjecent.map do |delta_x, delta_y|
      input[y + delta_y][x + delta_x] if delta_x + x >= 0 && delta_y + y >= 0 && delta_x + x < cols && delta_y + y < rows
    end.compact

    if neighbors.all? { |n| n > input[y][x] }
      basins << basin.call([y, x], y, x).flatten.uniq.count
    end
  end
end

puts "Part 2: #{basins.max(3).reduce(:*)}"
