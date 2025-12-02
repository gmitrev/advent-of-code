require_relative '../../common'

input = read_input_lines

input = input.map do |line|
  dir, *num = line.chars
  num = num.join.to_i

  dir == 'L' ? -num : num.to_i
end

start = 50
pass = 0

input.each do |n|
  start += n
  pass += 1 if start % 100 == 0
end

solve(1, pass)

start = 50
pass = 0

input.each do |n|
  n.abs.times do
    start += n > 0 ? 1 : -1

    pass += 1 if start % 100 == 0
  end
end

solve(2, pass)
