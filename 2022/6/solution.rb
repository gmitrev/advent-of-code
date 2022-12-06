input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).map(&:chars)

input.each do |line|
  line.each_cons(4).each.with_index do |g, i|
    if g.uniq.count == 4
      puts "Part 1: #{i+4}"
      break
    end
  end

  line.each_cons(14).each.with_index do |g, i|
    if g.uniq.count == 14
      puts "Part 2: #{i+14}"
      break
    end
  end
end
