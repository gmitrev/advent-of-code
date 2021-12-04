require "matrix"
require "set"

# input = File.read("example_input").each_line.map(&:strip)
input = File.read("input").each_line.map(&:strip)

# Part 1
numbers = input.shift.split(",").map(&:to_i)

boards = input.reject(&:empty?).map { |l| l.split(" ").map(&:to_i) }.each_slice(5).map(&:flatten)

bingo = nil

numbers.each do |number|
  break if bingo

  boards = boards.map do |board|
    board.map { |n| n == number ? nil : n }
  end

  boards.each do |board|
    matrix = Matrix[*board.each_slice(5).to_a]
    bingo_x = matrix.to_a.any? { |row| row.all?(&:nil?) }
    bingo_y = matrix.transpose.to_a.any? { |row| row.all?(&:nil?) }

    if bingo_x || bingo_y
      bingo = number * board.compact.sum
      break
    end
  end
end

puts "Part 1: #{bingo}"

# Part 2
boards = input.reject(&:empty?).map { |l| l.split(" ").map(&:to_i) }.each_slice(5).map(&:flatten)

bingo = nil
bingos = Set.new

numbers.each do |number|
  break if bingo

  boards = boards.map do |board|
    board.map { |n| n == number ? nil : n }
  end

  boards.each_with_index do |board, index|
    matrix = Matrix[*board.each_slice(5).to_a]
    bingo_x = matrix.to_a.any? { |row| row.all?(&:nil?) }
    bingo_y = matrix.transpose.to_a.any? { |row| row.all?(&:nil?) }

    if bingo_x || bingo_y
      bingos << index

      if bingos.count == boards.count
        bingo = number * board.compact.sum
        break
      end
    end
  end
end

puts "Part 2: #{bingo}"
