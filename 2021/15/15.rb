require "pqueue"
require "set"

input = File.read("input").lines(chomp: true).map { |l| l.chars.map(&:to_i) }

def dijkstra(board, start)
  size = board.size

  distance = {}
  queue = PQueue.new { |a, b| distance[a] < distance[b] }
  visited = Set.new

  size.times.each do |x|
    size.times.each do |y|
      distance[[y, x]] = Float::INFINITY
    end
  end

  distance[[0, 0]] = 0
  queue.push([0, 0])

  get_neighbors = ->((y, x)) do
    nb = []

    nb << [y + 1, x] if y < size - 1
    nb << [y - 1, x] if y > 0
    nb << [y, x + 1] if x < size - 1
    nb << [y, x - 1] if x > 0

    nb
  end

  until queue.empty?
    vertex = queue.pop
    visited << vertex

    neighbors = get_neighbors.call(vertex)

    neighbors.each do |neighbor|
      next if visited.member? neighbor

      alt = distance[vertex] + board[neighbor[0]][neighbor[1]]

      if alt < distance[neighbor]
        distance[neighbor] = alt

        queue.push(neighbor)
      end
    end
  end

  distance
end

part1 = dijkstra(input, [0, 0])
puts "Part 1: #{part1[[input.size - 1, input.size - 1]]}"

def fivefold(board)
  board.size.times do |n|
    line = board[n]
    4.times do |a|
      new_line = line.map { |n| n + 1 > 9 ? 1 : n + 1 }
      board[n] += new_line

      line = new_line
    end
  end

  board
end

input = fivefold(input)
input = fivefold(input.transpose)
input = input.transpose

part2 = dijkstra(input, [0, 0])
puts "Part 2: #{part2[[input.size - 1, input.size - 1]]}"
