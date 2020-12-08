# input = File.read('input').each_line.map { |l| l.strip }
input = File.read('input').each_line.map { |l| l.strip }

class Bag
  attr_accessor :contents, :name

  def initialize(name)
    @name = name
    @contents = []
  end

  def contains?(color)
    return false if @contents.empty?

    return true if @contents.any? { |b| b.first.name == color }

    @contents.any? { |b| b.first.contains? color }
  end

  def content_count
    @count ||=
      begin
        return 1 if @contents.empty?

        1 + @contents.sum { |b, c| b.content_count * c }
      end
  end
end

bags = {}

input.each do |l|
  a, _b = l.split('contain')

  outermost = a.match(%r{(.*) bags })[1]

  bags[outermost] = Bag.new(outermost)
end

input.each do |l|
  a, b = l.split('contain')

  outermost = a.match(%r{(.*) bags })[1]

  b.split(',').each do |g|
    innermost = g.strip.match(%r{(?<number>\d*) (?<color>.*) bag(.)*})
    if innermost && !innermost['number'].empty?
      bags[outermost].contents << [bags[innermost['color']], innermost['number'].to_i]

    end
  end
end

pp "[Part 1] Bags: " + bags.count { |k, v| v.contains?('shiny gold') }.to_s

pp "[Part 2] Bags: " + (bags['shiny gold'].content_count - 1).to_s
