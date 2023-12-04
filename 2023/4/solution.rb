input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

tickets = Array.new(input.length)

part1 = input.sum do |line|
  parsed = line.match(/Card\s*(?<index>\d+): (?<draw>[\d\s?]+)* \| (?<guesses>[\d\s?]+)*/)
  draw = parsed[:draw].split(" ").map(&:to_i)
  guesses = parsed[:guesses].split(" ").map(&:to_i)
  index = parsed[:index].to_i - 1

  winning = draw & guesses

  tickets[index] = winning.count

  next 0 if winning.empty?

  2**(winning.count - 1)
end

puts "Part 1: #{part1}"

total_cards = 0
queue = input.size.times.to_a

until queue.empty?
  total_cards += 1

  card = queue.shift

  matching = tickets[card]

  next if matching.zero?

  copies = ((card + 1)..(card + matching))
  queue.concat(copies.to_a)
end

puts "Part 2: #{total_cards}"
