require "set"

input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

keymap = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]

x = y = 1
part1 = []

input.each do |line|
  line.chars.each do |dir|
    case dir
    when "U" then x = (x - 1).clamp(0, 2)
    when "D" then x = (x + 1).clamp(0, 2)
    when "L" then y = (y - 1).clamp(0, 2)
    when "R" then y = (y + 1).clamp(0, 2)
    end
  end

  part1 << keymap[x][y]
end

puts "Part 1: #{part1.join}"

keymap = [
  [nil, nil, 1, nil, nil],
  [nil, 2, 3, 4, nil],
  [5, 6, 7, 8, 9],
  [nil, "A", "B", "C", nil],
  [nil, nil, "D", nil, nil]
]

x = 2
y = 0
part1 = []

input.each do |line|
  line.chars.each do |dir|
    case dir
    when "U"
      new_x = (x - 1).clamp(0, 4)
      x = new_x if keymap[new_x][y]
    when "D"
      new_x = (x + 1).clamp(0, 4)
      x = new_x if keymap[new_x][y]
    when "L"
      new_y = (y - 1).clamp(0, 4)
      y = new_y if keymap[x][new_y]
    when "R"
      new_y = (y + 1).clamp(0, 4)
      y = new_y if keymap[x][new_y]
    end
  end

  part1 << keymap[x][y]
end

puts "Part 2: #{part1.join}"
