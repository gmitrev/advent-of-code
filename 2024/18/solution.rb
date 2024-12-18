require 'pqueue'
require_relative '../../common.rb'

input = read_input_lines.map { |c| c.split(',').map(&:to_i) }
i input

def get_neighbors(y, x, size)
  nb = {}

  nb[:s] = [y + 1, x] if y < size - 1
  nb[:n] = [y - 1, x] if y > 0
  nb[:e] = [y, x + 1] if x < size - 1
  nb[:w] = [y, x - 1] if x > 0

  nb
end

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

  until queue.empty?
    y, x = queue.pop
    vertex = [y, x]
    visited << vertex

    neighbors = get_neighbors(*vertex, size)

    neighbors.each do |dir, neighbor|
      next if visited.member? neighbor

      neighbor_tile = board.dig(neighbor[0], neighbor[1])

      next if neighbor_tile == '#'

      score = distance[vertex] + 1

      if score < distance[neighbor]
        distance[neighbor] = score
        prev[neighbor] = vertex

        queue.push(neighbor)
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

start = [0, 0]

# Example
if test?
  board = 7.times.map do
    Array.new(7, '.')
  end

  input.first(12).each do |x, y|
    board[y][x] = '#'
  end

  board.each do |line|
    d line.join
  end

  finish = [6, 6]
else
  board = 71.times.map do
    Array.new(71, '.')
  end

  input.first(1024).each do |x, y|
    board[y][x] = '#'
  end

  finish = [70, 70]
end

path, distance = dijkstra(board, start, finish)

solve(1, distance)

# Reset board
if test?
  board = 7.times.map do
    Array.new(7, '.')
  end
else
  board = 71.times.map do
    Array.new(71, '.')
  end
end

benchmark do
  latest_path, _ = dijkstra(board, start, finish)

  part2 =
    input.detect do |x, y|
      board[y][x] = '#'

      next unless latest_path.include?([y,x])

      path, distance = dijkstra(board, start, finish)
      latest_path = path

      distance.infinite?
    end

  solve(2, part2.join(','))
end
