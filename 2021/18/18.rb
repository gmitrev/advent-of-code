input = File.read("example_input").lines(chomp: true)

number = "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"

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

parse_number(number)

Pair = Struct.new(:x, :y)

arr = eval(number)

def fuck(ary)
  if ary.is_a?(Array)
    pp ary
    ary.map do |a1, a2|
      Pair.new(fuck(a1), fuck(a2))
    end
  else
    ary
  end
end

res = fuck(arr)
puts res.inspect
