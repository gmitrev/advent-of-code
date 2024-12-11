require_relative '../../common.rb'

# lanternfish 👀
input = read_input.split(" ").map(&:to_i)
i input

cache = {}

workwork = ->(blinks, number) do
  return cache[[blinks, number]] if cache[[blinks, number]]

  return 1 if blinks.zero?

  res =
    if number.zero?
      workwork.call(blinks - 1, 1)
    elsif (string = number.to_s; string.size.even?)
      mid = string.size / 2
      n1 = string[0...mid].to_i
      n2 = string[mid..-1].to_i

      workwork.call(blinks - 1, n1) + workwork.call(blinks - 1, n2)
    else
      workwork.call(blinks - 1, number * 2024)
    end

  cache[[blinks, number]] = res

  res
end

benchmark do
  part1 = input.sum { |i| workwork.call(25, i) }
  solve(1, part1)
end

benchmark do
  part2 = input.sum { |i| workwork.call(75, i) }
  solve(2, part2)
end
