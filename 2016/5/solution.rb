require "digest"

input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)[0]

password = ""
password2 = Array.new(8)
index = 0

match = "00000".freeze

loop do
  checksum = Digest::MD5.hexdigest("#{input}#{index}")

  if checksum[..4] == match
    password << checksum[5] if password.length < 8

    if (pos = checksum[5]) && pos =~ /\d/ && (pos = pos.to_i) < 8 && !password2[pos]
      password2[pos] = checksum[6]
    end
  end

  break if password.length == 8 && password2.compact.size == 8
  index += 1
end

puts "Part 1: #{password}"
puts "Part 2: #{password2.join("")}"
