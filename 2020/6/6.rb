require 'set'

input = File.read('input').each_line.map { |l| l.strip }

# Part 1
answers = Set.new
total = 0

input.each do |line|
  if line.empty?
    total += answers.count
    answers = Set.new
  else
    answers += Array(line.split(''))
  end
end

# don't forget final line
total += answers.count

puts "[Part 1] Answers: #{total}"

# Part 2
answers = ('a'..'z').to_a
total = 0

input.each do |line|
  if line.empty?
    total += answers.count
    answers = ('a'..'z').to_a
  else
    answers &= Array(line.split(''))
  end
end

# don't forget final line
total += answers.count

puts "[Part 2] Answers: #{total}"
