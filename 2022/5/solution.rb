input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

stacks = Hash.new { |h, k| h[k] = [] }

crates, instructions = input.slice_before { |line| line.empty? }.to_a

crates.each do |line|
  line.chars.each_with_index do |crate, index|
    next unless crate =~ /[A-Z]/

    stack = index.divmod(4).sum.to_s

    stacks[stack] << crate
  end
end

stacks = stacks.sort_by { _1 }.to_h
stacks2 = Marshal.load(Marshal.dump(stacks))

instructions.drop(1).each do |instruction|
  n, from, to =  instruction.scan(/\d+/)

  n.to_i.times do
    stacks[to].unshift(stacks[from].shift)
  end

  stacks2[to].unshift(*stacks2[from].shift(n.to_i))
end

puts "Part 1: #{stacks.map { _2.first }.join}"
puts "Part 2: #{stacks2.map { _2.first }.join}"
