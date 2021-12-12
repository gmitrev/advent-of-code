require "set"

input = File.read("input").each_line.map(&:strip).map(&:chars).map { |l| l.map(&:to_i) }

verbose = ENV["VERBOSE"]

cols = input.first.size

board = input.flatten

# Print
puts board.each_slice(cols).map(&:join) if verbose

flashes = 0

step = ->(index) do
  puts "\nStep #{index + 1}" if verbose
  board = board.map(&:succ)

  flashed = Set.new

  adjacent = ->(position) do
    l = [position + cols, position - cols]

    # Left side
    unless (cols + position) % cols == 0
      l += [position - 1, position - cols - 1, position + cols - 1]
    end

    # Right side
    unless (cols + position) % cols == cols - 1
      l += [position + 1, position - cols + 1, position + cols + 1]
    end

    l.select { |l| l >= 0 && l <= board.size }
  end

  flash = ->(position) do
    return if flashed.member?(position)

    flashed << position

    board[position] = nil

    adjacent.call(position).each do |adj|
      board[adj] += 1 if board[adj]
    end
  end

  while (booyah = board.find { |x| x && x > 9 })
    booyah = board.index(booyah)
    flash.call(booyah)
  end

  flashed.each do |pos|
    board[pos] = 0
  end

  flashes += flashed.count

  if board.sum == 0
    raise "KOR"
  end

  if verbose
    board.each_with_index do |n, index|
      if flashed.member? index
        n = "\033[1m#{n}\033[0m"
        print "\e[34m#{n}\e[0m"
      else
        print n
      end

      puts if (index + 1) % cols == 0
    end
  end
end

100.times do |i|
  step.call(i)
end

puts "Part 1: #{flashes}"

board = input.flatten

i = 0
loop do
  step.call(i)

  i += 1
rescue
  puts "Part 2: #{i + 1}"
  break
end
