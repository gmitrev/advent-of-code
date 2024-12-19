require_relative '../../common.rb'

input = read_input

patterns, designs = input.split("\n\n")
patterns = Set.new(patterns.split(",").map(&:strip))
designs = designs.split("\n")
d patterns

patterns_regexp = /^#{Regexp.union(*patterns)}+$/

part1 = designs.count do |design|
  design.match?(patterns_regexp)
end

solve(1, part1)

cache = {}

count_all = ->(design) do
  return 1 if design.empty?

  cache[design] ||= patterns.select { |p| design.start_with?(p) }.sum do |p|
    count_all.(design[p.length..])
  end
end


part2 = designs.sum do |design|
  count_all.(design)
end

solve(2, part2)
