input = File.read('input').each_line.map { |l| l.strip.split '' }

cols = input.first.size - 1
rows = input.size - 1

# Part 1
x = y = trees = 0

while y <= rows && x <= cols
  x += 1
  y += 2

  x -= cols + 1 if x > cols

  break if y > rows

  trees += 1 if input[y][x] == '#'
end

puts "[Part 1] Trees: #{trees}"

# Part 2
results = []

[[1,1], [3,1], [5,1], [7,1], [1,2]].each do |slope|
  x = y = trees = 0

  while y <= rows && x <= cols
    x += slope[0]
    y += slope[1]

    x -= cols + 1 if x > cols

    break if y > rows

    trees += 1 if input[y][x] == '#'
  end

  results << trees
end

puts "[Part 2] Product: #{results.reduce(&:*)}"
