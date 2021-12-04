# input = File.read("example_input").strip
input = File.read("input").strip

# Part 1
puts "Part 1: " + input.each_char.map { |c| c == "(" ? 1 : -1 }.sum.to_s

# Part 2
z = 0

input.each_char.with_index do |c, i|
  c == "(" ? z += 1 : z -= 1

  if z == -1
    puts "Part 2: #{i + 1}"
    break
  end
end
