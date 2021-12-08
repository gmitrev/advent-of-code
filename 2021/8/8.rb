# input = File.read("example_input").each_line.map(&:strip)
input = File.read("input").each_line.map(&:strip)
# input = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]
digits = 0

input.each do |line|
  _, output = line.split(" | ")
  digits += output.split(" ").count { |c| [2, 3, 4, 7].include?(c.size) }
end

puts "Part 1: #{digits}"

map = {}
positions = {}
sum = 0

input.each do |line|
  signals, output = line.split(" | ").map { |l| l.split(" ") }

  signals.each do |signal|
    case signal.size
    when 2
      map[1] = signal.chars.sort
    when 3
      map[7] = signal.chars.sort
    when 4
      map[4] = signal.chars.sort
    when 7
      map[8] = signal.chars.sort
    else
      signal
    end
  end

  positions[0] = (map[7] - map[1]).first
  positions[2] = positions[5] = map[1]
  positions[1] = positions[3] = map[4] - map[1]

  # 6
  six = signals.find do |signal|
    diff = signal.chars - positions[2]

    signal.size == 6 && diff.size == 5
  end
  map[6] = six.chars.sort

  if map[6].include?(positions[2][0])
    positions[5], positions[2] = positions[2]
  elsif map[6].include?(positions[2][1])
    positions[2], positions[5] = positions[2]
  end

  # 0 && 9
  signals.each do |signal|
    diff = signal.chars - positions[3]

    if signal.size == 6 && signal.chars.sort != map[6]
      if diff.size == 4
        map[9] = signal.chars.sort
      else
        map[0] = signal.chars.sort
      end
    end
  end

  if map[0].include?(positions[1][0])
    positions[1], positions[3] = positions[1]
  elsif map[6].include?(positions[1][1])
    positions[3], positions[1] = positions[1]
  end

  positions[6] = (map[9] - positions.slice(0, 1, 2, 3, 5).values).first

  positions[4] = (map[0] - positions.slice(0, 1, 2, 3, 5, 6).values).first

  map[2] = positions.slice(0, 2, 3, 4, 6).values.sort
  map[3] = positions.slice(0, 2, 3, 5, 6).values.sort
  map[5] = positions.slice(0, 1, 3, 5, 6).values.sort

  output = output.map do |n|
    map.invert[n.chars.sort]
  end

  sum += output.join.to_i
end

puts "Part 2: #{sum}"
