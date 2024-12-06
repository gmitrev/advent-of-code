require_relative '../../common.rb'

input = read_input_lines
debug input

initial_guard_pos = nil
direction = :n

map = input.map.with_index do |row, y|
  row.chars.map.with_index do |char, x|
    initial_guard_pos = [y, x] if char == '^'
    char
  end
end

guard_pos = initial_guard_pos
visited = Set.new([guard_pos])

positions = {
  w: [0, -1],
  s: [1, 0],
  e: [0, 1],
  n: [-1, 0],
}
dirs = positions.keys

loop do
  next_pos = guard_pos.zip(positions[direction]).map(&:sum)
  at_next_pos = map.dig(*next_pos)

  break if at_next_pos.nil? || next_pos.any? { |n| n < 0 }

  case at_next_pos
  when '#'
    direction = dirs[dirs.index(direction)-1]
  else
    visited << next_pos

    guard_pos = next_pos
  end
end

solve(1, visited.count)

benchmark do
  part2 = visited.sum do |pos|
    guard_pos = initial_guard_pos
    direction = :n

    visited = Set.new([guard_pos])
    visited_with_dir = Set.new([guard_pos + [direction]])

    loop_detected = false

    loop do
      next_pos = guard_pos.zip(positions[direction]).map(&:sum)
      at_next_pos = map.dig(*next_pos)

      loop_detected = visited_with_dir.include?(next_pos + [direction])

      break if at_next_pos.nil? || next_pos.any? { |n| n < 0 } || loop_detected

      # Put obstacle
      at_next_pos = '#' if next_pos == pos

      case at_next_pos
      when '#'
        direction = dirs[dirs.index(direction)-1]
      else
        visited << next_pos
        visited_with_dir << next_pos + [direction]

        guard_pos = next_pos
      end
    end

    loop_detected ? 1 : 0
  end

  solve(2, part2)
end
