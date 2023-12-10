input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).reject(&:empty?)

parts = input.map do |line|
  seq = line.split.map(&:to_i)

  lines = [seq]
  latest = seq

  until latest.all?(&:zero?)
    latest = latest.each_cons(2).map { |a, b| b - a }
    lines << latest
  end

  first = last = 0

  lines.reverse.each do |line|
    last = line.last + last
    first = line.first - first
  end

  [first, last]
end

puts "Part 1: #{parts.sum(&:last)}"
puts "Part 2: #{parts.sum(&:first)}"
