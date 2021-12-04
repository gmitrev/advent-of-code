# input = File.read("example_input").each_line.map(&:strip)
input = File.read("input").each_line.map(&:strip)

# Part 1
gamma_rate = []
epsilon_rate = []

(0...input.first.size).each do |i|
  col =
    input.map do |line|
      line[i].chars
    end.flatten

  bits = col.map(&:to_i).sum > (col.count / 2) ? [1, 0] : [0, 1]

  gamma_rate << bits[0]
  epsilon_rate << bits[1]
end

gamma_rate = gamma_rate.map(&:to_s).join.to_i(2)
epsilon_rate = epsilon_rate.map(&:to_s).join.to_i(2)

puts "Part 1: #{gamma_rate * epsilon_rate}"

# Part 2
o2 = 0

o2list = input.dup
(0...o2list.first.size).each do |i|
  col =
    o2list.map do |line|
      line[i].chars
    end.flatten

  most_common = col.map(&:to_i).sum.to_f >= (col.count / 2.0) ? 1 : 0

  o2list.delete_if { |line| line[i].to_i != most_common }

  if o2list.count == 1
    o2 = o2list.first.to_i(2)
    break
  end
end

co2 = 0

co2list = input.dup
(0...co2list.first.size).each do |i|
  col =
    co2list.map do |line|
      line[i].chars
    end.flatten

  most_common = col.map(&:to_i).sum.to_f >= (col.count / 2.0) ? 0 : 1

  co2list.delete_if { |line| line[i].to_i != most_common }

  if co2list.count == 1
    co2 = co2list.first.to_i(2)
    break
  end
end

puts "Part 2: #{o2 * co2}"
