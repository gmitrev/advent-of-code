require_relative '../../common.rb'

input = read_input
debug input

rules, pages = input.split("\n\n").map { |i| i.each_line(chomp: true) }

pages = pages.map { |page| page.split(',').map(&:to_i) }

Rule = Struct.new(:number, :bigger) do
  def <=>(other)
    return 0 if other.number == number
    return -1 if bigger.include?(other.number)
    1
  end
end

rules =
  rules.map do |rule|
    rule.split('|').map(&:to_i)
  end.reduce(Hash.new { |h, k| h[k] = [] }) do |memo, (key, value)|
    memo[key] << value
    memo
  end.to_h do |k, v|
    [k, Rule.new(k, v)]
  end

part1 = pages.sum do |page|
  sorted = page.map { |p| rules[p] }.sort.map(&:number)
  sorted == page ? page[page.size/2] : 0
end

solve(1, part1)

part2 = pages.sum do |page|
  sorted = page.map { |p| rules[p] }.sort.map(&:number)
  sorted == page ? 0 : sorted[sorted.size/2]
end

solve(2, part2)
