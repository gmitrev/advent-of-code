input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).to_h do |line|
  game, rounds = line.split(":")
  game_id = game.split(" ").last.to_i

  rounds = rounds.split(";").map do |round|
    round.split(",").map do |draw|
      num, color = draw.split(" ")

      [color.to_sym, num.to_i]
    end
  end

  [game_id, rounds]
end

balls = {
  red: 12,
  green: 13,
  blue: 14
}

part1 = input.sum do |game_id, rounds|
  valid = rounds.all? do |round|
    round.all? do |color, number|
      number <= balls[color]
    end
  end

  valid ? game_id : 0
end

puts "Part 1: #{part1}"

part2 = input.sum do |_game_id, rounds|
  min = {red: nil, green: nil, blue: nil}

  rounds.each do |round|
    round.each do |color, number|
      min[color] ||= number # seen
      min[color] = [number, min[color]].max
    end
  end

  min.values.compact.reduce(:*)
end

puts "Part 2: #{part2}"
