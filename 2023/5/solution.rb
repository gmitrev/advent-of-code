input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

maps = input.slice_before { |l| l.empty? }.map do |group|
  group.reject(&:empty?)
end

seeds = maps.shift[0].scan(/\d+/).map(&:to_i)

maps = maps.map do |group|
  group.drop(1).map { |l| l.split(" ").map(&:to_i) }.map do |dest, source, range|
    [dest, (source...(source + range)), range]
  end
end

part1 = seeds.map do |seed|
  maps.each do |map|
    matching = map.find { |m| m[1].cover?(seed) }

    seed =
      if matching
        seed - matching[1].first + matching[0]
      else
        seed
      end
  end

  seed
end.min

puts "Part 1: #{part1}"

seeds = seeds.each_slice(2).to_a.map { |a, b| (a...(a + b)) }

part2 = seeds.map do |range|
  min = (1.0 / 0.0)

  puts "Range #{range}: #{Time.now}"
  range.each do |seed|
    maps.each do |map|
      matching = map.find { |m| m[1].cover?(seed) }

      seed =
        if matching
          seed - matching[1].first + matching[0]
        else
          seed
        end
    end

    min = [min, seed].min
  end

  puts "#{range}: #{min}"
  min
end.min

puts "Part 2: #{part2}"
