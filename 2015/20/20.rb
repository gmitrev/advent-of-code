require "prime"

# input = File.read("example_input").strip.each_line.map(&:strip).compact
input = File.read("input").strip.each_line.map(&:strip).first.to_i

def divisors(n)
  arr = Prime.prime_division(n).map { |v, exp| (0..exp).map { |i| v**i } }
  arr.first.product(*arr[1..]).map { |a| a.reduce(:*) }.map { |m| [m, n / m] }
end

house = 100_000

loop do
  presents = divisors(house).map(&:first).map { |a| a * 10 }.sum

  if presents >= input
    puts "Part 1: #{house}"
    break
  end

  house += 1
end

house = 100_000

loop do
  presents = divisors(house).map(&:first).map { |a| house / a > 50 ? 0 : a * 11 }.sum

  if presents >= input
    puts "Part 2: #{house}"
    break
  end

  house += 1
end
