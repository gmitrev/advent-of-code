input = File.read("input").strip.each_line.map(&:strip)

# Part 1
string = input.first

40.times do
  prev = nil

  string = string.chars.slice_before do |cur|
    prev, prev2 = cur, prev
    cur != prev2
  end.map { |group| "#{group.size}#{group.first}" }.join
end

puts "Part 1: #{string.length}"

# Part 2
string = input.first

50.times do
  prev = nil

  string = string.chars.slice_before do |cur|
    prev, prev2 = cur, prev
    cur != prev2
  end.map { |group| "#{group.size}#{group.first}" }.join
end

puts "Part 2: #{string.length}"
