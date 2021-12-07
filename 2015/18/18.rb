# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip.each_line.map(&:strip)

board = input.map(&:chars)

neighBROs = [0, 1, -1, 1, -1].permutation(2).to_a.uniq

rows = input.size

100.times do |i|
  new_board = Array.new(rows) { Array.new(rows) }

  (0...rows).each do |x|
    (0...rows).each do |y|
      neighbors_on = neighBROs.map do |delta_x, delta_y|
        board[y + delta_y][x + delta_x] if delta_x + x >= 0 && delta_y + y >= 0 && delta_x + x < rows && delta_y + y < rows
      end.compact.count { |n| n == "#" }

      cell = board[y][x]

      new_board[y][x] =
        if (cell == "#" && [2, 3].include?(neighbors_on)) || (cell == "." && neighbors_on == 3)
          "#"
        else
          "."
        end
    end
  end

  board = new_board
end

puts board.map { |l| l.join }

puts "Part 1: #{board.flatten.count { |c| c == "#" }}"

board = input.map(&:chars)
corners = [0, 0, rows - 1, rows - 1].permutation(2).to_a.uniq

corners.each do |x, y|
  board[x][y] = "#"
end

100.times do |i|
  new_board = Array.new(rows) { Array.new(rows) }

  (0...rows).each do |x|
    (0...rows).each do |y|
      neighbors_on = neighBROs.map do |delta_x, delta_y|
        board[y + delta_y][x + delta_x] if delta_x + x >= 0 && delta_y + y >= 0 && delta_x + x < rows && delta_y + y < rows
      end.compact.count { |n| n == "#" }

      cell = board[y][x]

      new_board[y][x] =
        if (cell == "#" && [2, 3].include?(neighbors_on)) || (cell == "." && neighbors_on == 3) || corners.include?([y, x])
          "#"
        else
          "."
        end
    end
  end

  board = new_board
end

puts board.map { |l| l.join }

puts "Part 2: #{board.flatten.count { |c| c == "#" }}"
