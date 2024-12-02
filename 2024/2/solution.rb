input_file = ENV["TEST"] ? "example_input" : "input"
# while true; do ruby solution.rb; sleep 0.3; done

input = File.read(input_file).lines(chomp: true).map { |l| l.split.map(&:to_i) }

def safe?(report)
  report.all? { |level| (1..3).cover?(level.abs) } &&
    (report.all? { |level| level > 0 } ||
     report.all? { |level| level < 0 })

end

part1 = input.count do |line|
  report = line.each_cons(2).map { |a, b| (a-b) }

  safe?(report)
end

puts "Part 1: #{part1}"

part2 = input.count do |line|
  report = line.each_cons(2).map { |a, b| (a-b) }

  next true if safe?(report)

  any_safe = false

  (0...line.size).any? do |c|
    permutation = line.reject.with_index { |el, i| i == c }
    report = permutation.each_cons(2).map { |a, b| (a-b) }
    safe?(report)
  end
end

puts "Part 2: #{part2}"
