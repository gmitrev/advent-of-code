input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

part1 = input.sum do |l|
  matches = l.match(/(?<letters>[a-z-]*)(?<sum>\d+)\[(?<checksum>\w+)\]/)

  letters = matches["letters"].tr("-", "").chars

  checksum = letters.tally.sort_by { |k, v| k.ord / v.to_f }.to_h.keys.take(5).join

  (checksum == matches["checksum"]) ? matches["sum"].to_i : 0
end

puts "Part 1: #{part1}"

input.each do |l|
  matches = l.match(/(?<letters>[a-z-]*)(?<sum>\d+)\[(?<checksum>\w+)\]/)

  letters = matches["letters"].tr("-", " ").chars

  letters = letters.map do |l|
    next " " if l == " "

    n = l.ord + matches["sum"].to_i.divmod(26)[1]
    n -= 26 if n > 122
    n.chr
  end.join("")

  puts "Part 2: #{matches["sum"]}" if letters.start_with?("north")
end
