input = File.read("input").each_line.map(&:strip).map(&:chars)

pairs = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

opening = pairs.keys
closing = pairs.values

points_errors = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

points_completion = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

illegals = []
completion_scores = []

input.each do |line|
  stack = []
  corrupted = false

  line.each do |char|
    if opening.include?(char)
      stack.unshift(char)
    elsif closing.include?(char)
      if pairs.invert[char] == stack[0]
        stack.shift
      else
        # puts "Incorrect closing character: #{char}; expected #{pairs[stack[0]]}"
        corrupted = true
        illegals << char
        break
      end
    end
  end

  if stack.any? && !corrupted
    missing = stack.map { |h| pairs[h] }

    score = missing.reduce(0) do |memo, n|
      (memo * 5) + points_completion[n]
    end

    completion_scores << score
  end
end

illegals_score = illegals.map { |c| points_errors[c] }.sum

puts "Part 1: #{illegals_score}"

completion_score = completion_scores.sort[(completion_scores.size / 2)]

puts "Part 2: #{completion_score}"
