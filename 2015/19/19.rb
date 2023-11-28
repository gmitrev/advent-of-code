require "set"

input = File.read("example_input").strip.each_line.map(&:strip).compact
# input = File.read("input").strip.each_line.map(&:strip).compact

*map, _, initial = input

mappings = Hash.new([])

map.each do |mapping|
  from, to = mapping.scan(/\w+/)

  mappings[from] += [to]
end

initial = initial.scan(/[A-Z][a-z]?/)

# Part 1
molecules = Set.new

initial.each_with_index do |molecule, index|
  mappings[molecule].each do |mapping|
    variation = initial.dup
    variation[index] = mapping

    variation = variation.join
    molecules << variation
  end
end

puts molecules.count

# Part 2
