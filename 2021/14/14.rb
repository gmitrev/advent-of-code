require "set"

verbose = ENV["VERBOSE"]

original_template, pairs = File.read("example_input").split("\n\n")
template = original_template.chars
pairs = pairs.each_line.map(&:strip).map { |p| p.split(" -> ") }.to_h

puts "Template: #{template}" if verbose

10.times do |i|
  new_template = []

  template.each_cons(2) do |a, b|
    new_template << a
    new_template << pairs["#{a}#{b}"]
  end

  new_template << template.last

  template = new_template
  puts "Step #{i.succ}: #{template.join}" if verbose
end

a, b = template.tally.values.sort.minmax
puts "Part 1: #{b - a}"

# Part 2
template = original_template.chars

cache = Hash.new(0)

template.each_cons(2).map { |a, b| cache[[a, b]] += 1 }

40.times do |i|
  tmp = Hash.new(0)

  cache.each do |(p1, p2), v|
    middle = pairs[p1 + p2]

    tmp[[p1, middle]] += v
    tmp[[middle, p2]] += v
  end

  cache = tmp
end

pp cache

counts = cache.map { |k, v| [k.first, v] }.each_with_object(Hash.new(0)) do |v, memo|
  memo[v[0]] += v[1]
end
pp counts

a, b = counts.values.minmax
puts "Part 2: #{b - a + 1}"
