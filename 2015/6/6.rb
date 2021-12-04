input = File.read("input").strip

REGEXP = Regexp.new(/(?<instruction>([a-z]|\s)*)(?<x1>\d{0,3}),(?<y1>\d{0,3}) through ((?<x2>\d{0,3})),((?<y2>\d{0,3}))/)

# Part 1
board = Array.new(1000).map { |r| Array.new(1000, 0) }

input.each_line.with_index do |line, index|
  parsed = line.match REGEXP
  instruction, x1, y1, x2, y2 = parsed.captures.map(&:strip)

  (y1.to_i..y2.to_i).each do |y|
    (x1.to_i..x2.to_i).each do |x|
      case instruction
      when "turn off"
        board[x][y] = 0
      when "turn on"
        board[x][y] = 1
      when "toggle"
        board[x][y] = 1 - board[x][y]
      end
    end
  end
end

puts "Part 1: #{board.flatten.count { |x| x == 1 }}"

# Part 2
board = Array.new(1000).map { |r| Array.new(1000, 0) }

input.each_line.with_index do |line, index|
  parsed = line.match REGEXP
  instruction, x1, y1, x2, y2 = parsed.captures.map(&:strip)

  (y1.to_i..y2.to_i).each do |y|
    (x1.to_i..x2.to_i).each do |x|
      case instruction
      when "turn off"
        board[x][y] = [0, board[x][y] - 1].max
      when "turn on"
        board[x][y] += 1
      when "toggle"
        board[x][y] += 2
      end
    end
  end
end

puts "Part 2: #{board.flatten.sum}"
