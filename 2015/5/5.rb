# input = File.read("example_input").strip
# input = File.read("example_input2").strip
input = File.read("input").strip

# Part 1
nice = 0
forbidden = %w[ab cd pq xy]
permitted_vowels = %w[a e i o u]

input.each_line.map(&:strip).each do |line|
  has_repeats = false
  vowels = 0

  line.chars.each_cons(2) do |a, b|
    pair = "#{a}#{b}"
    raise if forbidden.include?(pair)

    vowels += 1 if permitted_vowels.include?(a)

    has_repeats = true if a == b
  end

  vowels += 1 if permitted_vowels.include?(line.chars.last)

  nice += 1 if has_repeats && vowels >= 3
rescue
end

puts "Part 1: #{nice}"

# Part 2
nice = 0
input.each_line.map(&:strip).each do |line|
  pairs = []
  has_repeating_pairs = false
  has_repeating_letters = false

  line.chars.each_cons(3) do |a, b, c|
    has_repeating_pairs = true if pairs[0..].include?("#{b}#{c}")
    has_repeating_letters = true if a == c
    pairs << "#{a}#{b}"
  end

  nice += 1 if has_repeating_letters && has_repeating_pairs
end

puts "Part 2: #{nice}"
