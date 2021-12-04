require "json"

# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip

# Part 1
sum = input.scan(/-?\d+/).map(&:to_i).sum
puts "Part 1: #{sum}"

# Part 2
sum = 0
json = JSON.parse(input)

dive = ->(f) {
  case f
  when Hash
    return if f.value?("red")

    f.values.each do |value|
      dive.call(value)
    end
  when Integer
    sum += f
  when Array
    f.each do |value|
      dive.call(value)
    end
  end
}

dive.call(json)

puts "Part 2: #{sum}"
