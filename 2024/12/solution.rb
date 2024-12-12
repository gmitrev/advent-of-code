require_relative '../../common.rb'

input = read_input_lines

map = input.map(&:chars)

Plot = Struct.new(:block, :y, :x) do
  attr_accessor :same_neighbors, :angles

  def initialize(block, y, x)
    super(block, y, x)

    @same_neighbors = Set.new
    @angles = 0
  end

  def outer_sides
    4 - @same_neighbors.size
  end

  def sym
    block.sym
  end

  def print(angles = false)
    if angles
      [sym, @angles.inspect].join(':')
    else
      inspect
    end
  end

  def inspect
    [sym, outer_sides].join(':')
  end
end

Block = Struct.new(:sym, :block_id) do
  attr_accessor :plots

  def initialize(sym, block_id)
    super(sym, block_id)
    @plots = []
  end

  def to_s
    [sym, @plots.size].join(': ')
  end
end

blocks = []

print_map = ->(angles = false) do
  map.each do |line|
    d line.map { |i| i.print(angles) }.join(' ')
  end
end

nbs = [[-1, 0], [1, 0], [0, -1], [0, 1]]

get_neighbors = -> (y, x) do
  neighbors = nbs.map do |pos|
    [y,x].zip(pos).map(&:sum)
  end.reject { |h| h.any? { |i| i < 0 } }
end

crawl = ->(y, x, block) do
  plot = Plot.new(block, y, x)
  block.plots << plot
  map[y][x] = plot

  neighbors = get_neighbors.call(y, x)

  neighbors.each do |ny, nx|
    neighbor = map.dig(ny, nx)

    if neighbor.is_a?(Plot) && neighbor.sym == plot.sym
      neighbor.same_neighbors << plot
      plot.same_neighbors << neighbor
    elsif neighbor == block.sym
      crawl.(ny, nx, block)
    end
  end
end

yy = map.size
xx = map[0].size
block_id = 1

yy.times do |y|
  xx.times do |x|
    plot = map.dig(y, x)

    next if plot.is_a?(Plot)

    # Start a new block
    block = Block.new(plot, block_id)
    block_id += 1
    blocks << block
    crawl.(y, x, block)
  end
end

print_map.call

part1 = blocks.sum do |block|
  block.plots.count * block.plots.sum(&:outer_sides)
end

solve(1, part1)


# part 2
angles =   [
  [[-1, 0], [-1, -1], [0, -1]], # top left
  [[-1, 0], [-1,  1], [0,  1]], # top right
  [[0, -1], [1,  -1], [1,  0]], # bottom left
  [[0,  1], [1,   1], [1,  0]], # bottom right
]

calculate_angles = -> (plot) do
  angles.count do |angle|
    coords = angle.map do |pos|
      pos.zip([plot.y, plot.x]).map(&:sum)
    end

    a, b, c = coords.map { |coords| coords.any? { |c| c < 0 } ? nil : map.dig(*coords) }

    # Check if extruding or protruding angle
    (a&.block == plot.block && b&.block != plot.block && c&.block == plot.block) || (a&.block != plot.block && c&.block != plot.block)
  end
end

map.flatten.each do |plot|
  plot.angles = calculate_angles.(plot)
end


print_map.call(true)

part2 = blocks.sum do |block|
  block.plots.count * block.plots.sum(&:angles)
end

solve(2, part2)
