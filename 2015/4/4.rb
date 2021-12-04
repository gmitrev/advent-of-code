require "digest"

# input = File.read("example_input").strip
input = File.read("input").strip

# Part 1
n = 1
prefix = "00000"
loop do
  key = "#{input}#{n}"
  digest = Digest::MD5.hexdigest(key)

  if digest[0..4] == prefix
    puts "Part 1: #{n} #{digest}"
    break
  end

  n += 1
end

# Part 2
n = 1
prefix = "000000"
loop do
  key = "#{input}#{n}"
  digest = Digest::MD5.hexdigest(key)

  if digest[0..5] == prefix
    puts "Part 2: #{n} #{digest}"
    break
  end

  n += 1
end
