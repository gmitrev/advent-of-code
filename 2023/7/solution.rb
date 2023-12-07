input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

MAP = %w(A K Q J T 9 8 7 6 5 4 3 2).zip('A'..'Z').to_h

def strength(hand)
  scores = hand.chars.tally.values

  score =
    if scores.include?(5) # Five of a kind
      'A'
    elsif scores.include?(4) # Four of a kind
      'B'
    elsif scores.include?(3) && scores.include?(2) # Full house
      'C'
    elsif scores.include?(3)  # Three of a kind
      'D'
    elsif scores.include?(2) && scores.size == 3 # Two pairs
      'E'
    elsif scores.include?(2) # One pair
      'F'
    else
      'G'
    end

  score + hand.chars.map { |char| MAP[char] }.join
end

hands = input.map do |game|
  hand, bid = game.split(" ")

  [strength(hand), bid]
end.sort_by { |a, b| a }.reverse


part1 = hands.map.with_index do |(_, bid), i|
  bid.to_i * i.succ
end.sum

puts "Part 1: #{part1}"

MAP2 = %w(A K Q T 9 8 7 6 5 4 3 2 J).zip('A'..'Z').to_h

def strength2(hand)
  tally = hand.chars.tally
  scores = tally.values
  jokers = tally.fetch('J', 0)
  max = tally.reject { |k, v| k == "J" }.values.max || 0

  score =
    if max + jokers == 5 # Five of a kind
      'A'
    elsif max + jokers == 4 # Four of a kind
      'B'
    elsif (max == 3 && scores.include?(2)) || # Full house
      (max == 2 && scores.size == 3 && jokers == 1)
      'C'
    elsif max + jokers == 3 # Three of a kind
      'D'
    elsif (max == 2 && scores.size == 3) # Two pairs
      'E'
    elsif max == 2 || (max == 1 && jokers == 1) # One pair
      'F'
    else
      'G'
    end

  score + hand.chars.map { |char| MAP2[char] }.join
end

hands = input.map do |game|
  hand, bid = game.split(" ")

  [hand, strength2(hand), bid.to_i]
end.sort_by { |a, b, c| b }.reverse

part2 = hands.map.with_index do |(_, _, bid), i|
  bid.to_i * i.succ
end

puts "Part 2: #{part2.sum}"
