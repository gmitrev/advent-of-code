require_relative '../../common.rb'

ranges, ingredients = read_input.split("\n\n").map { |a| a.split("\n") }

ranges = ranges.map do |r|
  a, b = r.split('-').map(&:to_i)

  a..b
end

ingredients = ingredients.map(&:to_i)

solve(1, ingredients.count { |i| ranges.any? { |range| range.cover?(i) }})

dur = []

ranges.sort_by(&:first).each do |range|
  min, max = range.first, range.last

  covers_min = dur.find { |r| r.cover? min }
  covers_max = dur.find { |r| r.cover? max }

  if !covers_min && !covers_max
    dur << range
  elsif covers_min && covers_max
    dur.delete(covers_min)
    dur.delete(covers_max)

    dur << (covers_min.first..covers_max.last)
  elsif covers_min && !covers_max
    dur.delete(covers_min)

    dur << (covers_min.first..max)
  elsif !covers_min && covers_max
    dur.delete(covers_max)

    dur << (min..covers_max.last)
  end
end

solve(2, dur.sum(&:count))
