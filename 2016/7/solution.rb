input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

def supports_ipv7?(address)
  supports = nil
  in_brackets = false

  address.chars.each_cons(4) do |pair|
    if pair.include?("[")
      in_brackets = true
    elsif pair.include?("]")
      in_brackets = false
    end

    next if (pair & %w([ ])).any?

    match = pair[0] == pair[3] && pair[1] == pair[2] && pair[0] != pair[1]

    if !in_brackets && supports.nil? && match
      supports = true
    elsif in_brackets && match
      supports = false
    end
  end

  supports
end

part1 = input.count do |l|
  supports_ipv7?(l)
end

puts "Part 1: #{part1}"

def supports_ssl?(address)
  in_brackets = false
  aba = []
  bab = []

  address.chars.each_cons(3) do |pair|
    if pair.include?("[")
      in_brackets = true
    elsif pair.include?("]")
      in_brackets = false
    end

    next if (pair & %w([ ])).any?

    match = pair[0] == pair[2] && pair[0] != pair[1]

    next unless match

    if in_brackets
      bab << [pair[1], pair[0], pair[1]].join
    else
      aba << pair.join
    end
  end

  (aba & bab).any?
end

part2 = input.count do |l|
  supports_ssl?(l)
end

puts "Part 2: #{part2}"
