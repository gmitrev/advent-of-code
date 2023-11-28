verbose = ENV["VERBOSE"]

rolls = 0
die = 0

roll_once = -> do
  die = 0 if die == 100
  die += 1
  rolls += 1
  die
end

roll = -> do
  3.times.map { |r| roll_once.call }
end

# Example
positions = {player: 3, computer: 7}
# positions = {player: 7, computer: 1}

score = {player: 0, computer: 0}

current = :player

loop do
  forward = roll.call

  new_position = positions[current] + forward.sum

  new_position = new_position.remainder(10) if new_position > 9

  positions[current] = new_position
  score[current] += new_position + 1

  puts "#{rolls} #{current.to_s.ljust(10, " ")} rolls #{forward.join("+")} and moves to space #{new_position + 1} for a total score of #{score[current]}" if verbose

  break if score[current] >= 1000

  current = (positions.keys - [current]).first
end

puts "Part 1: #{score.values.min * rolls}"

# Part 2

cache = {}
wins = {0 => 0, 1 => 0}

play = ->(current, positions, scores, rolled = []) do
  key = current + positions + scores

  if rolled.count == 3
    # check win
    new_position = positions[current] + rolled.sum
    new_position = new_position.remainder(10) if new_position > 9

    positions[current] = new_position
    score[current] += new_position + 1

    if score[current] >= 21
      # WIN

    end
  end

  (1..3).each do |die|
  end
  pp key
end

play.call([0], [3, 7], [0, 0])
