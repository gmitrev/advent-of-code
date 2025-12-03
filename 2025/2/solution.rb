require_relative '../../common'

input = read_input

ranges = input.split(',')
ranges = ranges.map { |a| a.split('-').map(&:to_i) }

accumulator = 0

ranges.each do |min, max|
  (min..max).each do |n|
    chars = n.to_s.chars
    next if chars.size.odd?

    a, b = chars.each_slice(chars.size / 2.0).to_a.map(&:join)

    accumulator += n if a == b
  end
end

solve(1, accumulator)

accumulator = Set.new

ranges.each do |min, max|
  (min..max).each do |n|
    chars = n.to_s.chars

    1.upto(chars.size + 1).each do |slice_size|
      nums = chars.each_slice(slice_size).to_a.map(&:join)
      if nums.all? { |slice| slice == nums.first } && nums.size > 1
        i [n, nums]
        accumulator << n
      end
    end
  end
end

solve(2, accumulator.sum)
