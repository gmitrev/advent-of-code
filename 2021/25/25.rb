verbose = ENV["VERBOSE"]

input = File.read("input").lines(chomp: true).map(&:chars)

board = {}

yl = input.size
xl = input[0].size

def pr(board, yl, xl)
  yl.times do |y|
    xl.times do |x|
      print board.dig(y, x) || "."
    end
    puts
  end

  puts
end

yl.times do |y|
  board[y] ||= {}

  xl.times do |x|
    board[y][x] = input[y][x] if input[y][x] != "."
  end
end

i = 1

loop do
  tmp = {}
  moves = 0

  # East
  board.each do |y, line|
    tmp[y] ||= {}

    line.each do |x, cucumber|
      if cucumber == "v"
        tmp[y][x] = cucumber
      elsif x + 1 == xl && board.dig(y, 0).nil?
        tmp[y][0] = cucumber
        moves += 1
      elsif x + 1 < xl && board.dig(y, x + 1).nil?
        tmp[y][x + 1] = cucumber
        moves += 1
      else
        tmp[y][x] = cucumber
      end
    end
  end

  board = tmp

  # South
  tmp = {0 => {}}

  board.each do |y, line|
    tmp[y] ||= {}
    tmp[y + 1] ||= {}

    line.each do |x, cucumber|
      if cucumber == ">"
        tmp[y][x] = cucumber
      elsif y + 1 == yl && board.dig(0, x).nil?
        tmp[0][x] = cucumber
        moves += 1
      elsif y + 1 < yl && board.dig(y + 1, x).nil?
        tmp[y + 1][x] = cucumber
        moves += 1
      else
        tmp[y][x] = cucumber
      end
    end
  end

  board = tmp

  if moves == 0
    puts "Result: #{i}"
    break
  end
  i += 1
end
