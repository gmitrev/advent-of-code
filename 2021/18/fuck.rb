input = File.read("example_input").lines(chomp: true)

def visualize(number, label = nil)
  return unless ENV["VERBOSE"]

  current_level = 0

  print "#{label}: ".ljust(20, " ") if label

  number.each_with_index do |(n, level), index|
    if level != current_level
      delimiter = level > current_level ? "[" : "]"

      print delimiter * (level - current_level).abs

      current_level = level
    else
      print " "
    end

    print n

    print "]" * current_level if index + 1 == number.size
  end
  puts
end

def parse_number(snailfish_number)
  level = 0
  number = []

  snailfish_number.chars.each do |char|
    if char == "["
      level += 1
    elsif char == "]"
      level -= 1
    elsif /\d+/.match?(char)
      number << [char.to_i, level]
    end
  end

  number
end

def reduce(number)
  explode = ->(x1, x2) do
    level = number[x1][1]

    number[x1 - 1][0] += number[x1][0] if x1 - 1 >= 0
    number[x2 + 1][0] += number[x2][0] if x2 + 1 < number.size

    number.delete_at(x2)
    number[x1] = [0, level - 1]
  end

  split = ->(x) do
    level = number[x][1]
    n = number[x][0]

    number[x] = [(n.to_f / 2).floor, level + 1]
    number.insert(x + 1, [(n.to_f / 2).ceil, level + 1])
  end

  reduce = -> do
    to_explode = number.index { |x| x[1] > 4 }
    cycle = false

    if to_explode
      explode.call(to_explode, to_explode + 1)

      visualize(number, "After explode #{to_explode}")

      cycle = true
    end

    to_split = number.index { |x| x[0] > 9 }

    if !to_explode && to_split
      split.call(to_split)

      visualize(number, "After split #{to_split}")

      cycle = true
    end

    if cycle
      reduce.call
    else
      visualize(number, "Final")
    end
  end

  reduce.call

  number
end

def sum(n1, n2)
  (n1 + n2).map { |h| [h[0], h[1] + 1] }
end

input = input.map { |n| parse_number(n) }

final = input.reduce do |memo, el|
  reduce(sum(memo, el))
end

pp final.map(&:first)

def magnitude(snailfish_number)
  if snailfish_number.is_a?(Array)
    a, b = snailfish_number.map { |pair| magnitude(pair) }
    a * 3 + 2 * b
  else
    snailfish_number
  end
end

def to_nested_array(snailfish_number)
  snailfish_number
end

pp to_nested_array(final)
