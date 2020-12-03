input = File.read('input')

regex = %r{(?<range>\d*-\d*)\s(?<letter>\w):\s(?<password>\w*)}

# Part 1
valid = 0

input.each_line do |l|
  matches = l.strip.match regex
  min, max = matches['range'].split('-').map(&:to_i)

  occurences = matches['password'].count(matches['letter'])

  valid += 1 if  occurences >= min && occurences <= max
end

puts "[Part 1] Valid passwords: #{valid}"

# Part 2
valid = 0

input.each_line do |l|
  matches = l.strip.match regex
  first, second = matches['range'].split('-').map(&:to_i)

  first_letter_match = matches['password'][first - 1] == matches['letter']
  second_letter_match = matches['password'][second - 1] == matches['letter']

  valid += 1 if first_letter_match ^ second_letter_match
end

puts "[Part 2] Valid passwords: #{valid}"
