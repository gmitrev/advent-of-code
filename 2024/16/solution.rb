require 'pqueue'
require_relative '../../common.rb'

input = read_input_lines

# d input

start_at = end_at = nil

board = input.map.with_index do |row, y|
  row.chars.map.with_index do |col, x|
    start_at = [y,x] if col == 'S'
    end_at = [y,x] if col == 'E'
    col
  end
end

# i board
# i start_at
# i end_at

def dijkstra(board, start, finish)
  size = board.size

  distance = {}
  prev = {}
  queue = PQueue.new { |a, b| distance[a.first(2)] < distance[b.first(2)] }
  visited = Set.new

  size.times.each do |x|
    size.times.each do |y|
      distance[[y, x]] = Float::INFINITY
      prev[[y, x]] = nil
    end
  end

  distance[start] = 0
  queue.push(start + [:e])

  get_neighbors = ->((y, x)) do
    nb = {}

    nb[:s] = [y + 1, x] if y < size - 1
    nb[:n] = [y - 1, x] if y > 0
    nb[:e] = [y, x + 1] if x < size - 1
    nb[:w] = [y, x - 1] if x > 0

    nb
  end

  until queue.empty?
    y, x, direction = queue.pop
    vertex = [y, x]
    visited << vertex + [direction]

    neighbors = get_neighbors.call(vertex)

    neighbors.each do |dir, neighbor|
      next if visited.member? neighbor + [dir]

      neighbor_tile = board.dig(neighbor[0], neighbor[1])

      next if neighbor_tile == '#'

      score = distance[vertex] + (dir == direction ? 1 : 1001)

      if score < distance[neighbor]
        distance[neighbor] = score
        prev[neighbor] = vertex

        queue.push(neighbor + [dir])
      end
    end
  end


  # Reconstruct path
  cur = finish
  path = [cur]
  while cur = prev[cur]
    path << cur
  end

  [path, distance[finish]]
end

path, distance =  dijkstra(board, start_at, end_at)

solve(1, distance)

# PRINT
path.each do |y, x|
  board[y][x] = FULL_BLOCK
end

board.each do |row|
  d row.join
end

