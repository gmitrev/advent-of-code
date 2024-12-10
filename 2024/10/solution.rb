require_relative '../../common.rb'

input = read_input_lines
debug input

trailheads = Set.new

MAP = input.map.with_index do |row, y|
  row.chars.map.with_index do |col, x|
    trailheads << [y,x] if col == '0'
    col.to_i
  end
end

POSITIONS = {
  w: [0, -1],
  s: [1, 0],
  e: [0, 1],
  n: [-1, 0],
}

def neighbour(trailhead, direction)
  height = MAP.dig(*trailhead)

  coords = trailhead.zip(POSITIONS[direction]).map(&:sum)

  return nil if coords.any? { |c| c < 0 }

  neighbour_height = MAP.dig(*coords)

  neighbour_height == height + 1 ? coords : nil
end

def score(trailhead, visited)
  return 0 if trailhead.nil?

  height = MAP.dig(*trailhead)

  if height == 9
    visited << trailhead

    return 1
  end

  (
    score(neighbour(trailhead, :n), visited) +
    score(neighbour(trailhead, :s), visited) +
    score(neighbour(trailhead, :w), visited) +
    score(neighbour(trailhead, :e), visited)
  )
end

benchmark do
  part1 =
    trailheads.sum do |trailhead|
      visited_nines = Set.new
      score(trailhead, visited_nines)
      visited_nines.count
    end

  puts
  solve(1, part1)
end

benchmark do
  part2 =
    trailheads.sum do |trailhead|
      score(trailhead, [])
    end

  solve(2, part2)
end
