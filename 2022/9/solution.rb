require "set"
input_file = ENV["INPUT"] || "input"

input = File.read(input_file).lines(chomp: true).map { _1.split(" ") }

LINE_UP = "\033[1A"
LINE_CLEAR = "\x1b[2K"

head = [0, 0]
tail = [0, 0]

visited = Set.new
visited << tail.dup

print_board = -> do
  10.downto(-10).each do |y|
    -10.upto(10).each do |x|
      if [x,y] == head
        print "H"
      elsif [x,y] == tail
        print "T"
      else
        print "."
      end
    end
    puts
  end

  puts
  sleep 0.05

  22.times do |i|
    print LINE_UP
    print LINE_CLEAR
  end

end

move_tail = -> do
  should_move = (head[0] - tail[0]).abs > 1 || (head[1] - tail[1]).abs > 1

  return unless should_move

  if head[0] == tail[0]
    tail[1] += head[1] > tail[1] ? 1 : -1
  elsif head[1] == tail[1]
    tail[0] += head[0] > tail[0] ? 1 : -1
  else
    moves = [head[0] - tail[0], head[1] - tail[1]]
    tail[0] += moves[0] > 0 ? 1 : -1
    tail[1] += moves[1] > 0 ? 1 : -1
  end

  visited << tail.dup
end

input.each do |direction, steps|
  steps.to_i.times do
    case direction
    when "U"
      head[1] += 1
    when "R"
      head[0] += 1
    when "D"
      head[1] -= 1
    when "L"
      head[0] -= 1
    end

    move_tail.call
    print_board.call
  end
end

puts "Part 1: #{visited.count}"

# PART 2

knots = Array.new(10) { [0,0] }

visited = Set.new
visited << [0,0]

print_board = -> do
  15.downto(-5).each do |y|
    -11.upto(14).each do |x|
      i = knots.index([x,y])

      if i
        print i == 0 ? "H" : i
      else
        print "."
      end
    end
    puts
  end

  puts
  sleep 0.05

  22.times do |i|
    print LINE_UP
    print LINE_CLEAR
  end

end

move = ->(knot) do
  head = knots[knot-1]
  tail = knots[knot]

  should_move = (head[0] - tail[0]).abs > 1 || (head[1] - tail[1]).abs > 1

  return unless should_move

  if head[0] == tail[0]
    tail[1] += head[1] > tail[1] ? 1 : -1
  elsif head[1] == tail[1]
    tail[0] += head[0] > tail[0] ? 1 : -1
  else
    moves = [head[0] - tail[0], head[1] - tail[1]]
    tail[0] += moves[0] > 0 ? 1 : -1
    tail[1] += moves[1] > 0 ? 1 : -1
  end

  visited << tail.dup if knot == 9
end

input.each do |direction, steps|
  steps.to_i.times do
    case direction
    when "U"
      knots[0][1] += 1
    when "R"
      knots[0][0] += 1
    when "D"
      knots[0][1] -= 1
    when "L"
      knots[0][0] -= 1
    end

    (1..9).each { |knot| move.call(knot) }

    print_board.call
  end
end

puts "Part 2: #{visited.count}"
