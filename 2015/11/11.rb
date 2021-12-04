# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip.each_line.map(&:strip)

# Part 1
FORBIDDEN = %w[i o l]

def valid?(password)
  return false unless password.size == 8

  # Forbidden characters
  return false unless (FORBIDDEN & password).empty?

  # Increasing triplets
  triplets = password.each_cons(3)
  return false unless triplets.to_a.any? { |a, b, c| b == a.succ && c == b.succ }

  # Pairs
  pairs = []

  password.each_cons(2).with_index do |(a, b), index|
    pairs << index if a == b
  end

  return false unless pairs.size > 1 && pairs.each_slice(2).any? { |a, b| b > a + 1 }

  true
end

def generate_next_valid(password)
  until valid?(password.chars)
    password = password.succ
  end

  password
end

input.each do |password|
  first = generate_next_valid(password)
  puts "Part 1: #{first}"
  second = generate_next_valid(first.succ)
  puts "Part 2: #{second}"
end
