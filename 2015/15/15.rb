# input = File.read("example_input").strip.each_line.map(&:strip)
input = File.read("input").strip.each_line.map(&:strip)

lines = input.map { |l| l.scan(/-?\d+/).map(&:to_i) }
max = 0
max2 = 0

100.times do |a|
  100.times do |b|
    100.times do |c|
      100.times do |d|
        if a + b + c + d == 100
          capacity = (a * lines[0][0] + b * lines[1][0] + c * lines[2][0] + d * lines[3][0])
          capacity = 0 if capacity < 0
          durability = (a * lines[0][1] + b * lines[1][1] + c * lines[2][1] + d * lines[3][1])
          durability = 0 if durability < 0
          flavor = (a * lines[0][2] + b * lines[1][2] + c * lines[2][2] + d * lines[3][2])
          flavor = 0 if flavor < 0
          texture = (a * lines[0][3] + b * lines[1][3] + c * lines[2][3] + d * lines[3][3])
          texture = 0 if texture < 0

          calories = (a * lines[0][4] + b * lines[1][4] + c * lines[2][4] + d * lines[3][4])

          score = capacity * durability * flavor * texture

          max = [max, score].max
          max2 = [max2, score].max if calories == 500
        end
      end
    end
  end
end

puts "Part 1: #{max}"
puts "Part 2: #{max2}"
