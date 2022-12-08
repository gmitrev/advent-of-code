input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

Tree = Struct.new(:x, :y, :h, :visible, :scenic_scores)

forest = input.map.with_index do |row, x|
  row.chars.map.with_index do |tree, y|
    Tree.new(x, y, tree.to_i, false, [])
  end
end

process = -> (tree, ray) do
  wall = ray.index { _1 >= tree.h }
  tree.scenic_scores << (wall ? wall + 1 : ray.count)

  return if tree.visible

  tree.visible = ray.empty? ? true : tree.h > ray.max
end

forest.flatten.each do |tree|
  process.call(tree, forest[0...tree.x].map { |l| l[tree.y].h }.reverse)
  process.call(tree, forest[tree.x][tree.y+1..].map(&:h))
  process.call(tree, forest[tree.x+1..].map { |l| l[tree.y].h })
  process.call(tree, forest[tree.x][0...tree.y].map(&:h).reverse)
end

part1 = forest.flatten.count(&:visible)
puts "Part 1: #{part1}"

part2 = forest.flatten.map { _1.scenic_scores.reduce(:*) }.max
puts "Part 2: #{part2}"
