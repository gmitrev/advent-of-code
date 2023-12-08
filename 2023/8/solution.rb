require 'set'
input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true).reject(&:empty?)

directions = input.shift.chars
directions_count = directions.count

nodes = input.to_h do |line|
  node, *edges = line.scan(/[A-Z0-9]{3}/)
  [node, edges]
end

node = nodes['AAA']
cycle = 0

loop do
  direction = directions[cycle % directions_count]

  next_node = direction == 'L' ? 0 : 1
  next_node = node[next_node]
  break if next_node == 'ZZZ'

  node = nodes[next_node]

  cycle += 1
end

puts "Part 1: #{cycle + 1}"

cur = nodes.keys.select { |n| n.end_with?('A') }

loops = cur.map do |node_name|
  cycle = 1
  cycles_to_z = nil
  cycles_to_loop = nil
  seen = Set.new

  node = nodes[node_name]

  loop do
    direction = directions[(cycle - 1) % directions_count]

    next_node = direction == 'L' ? 0 : 1
    next_node = node[next_node]

    if next_node.end_with?('Z') && !cycles_to_z
      cycles_to_z = cycle
    end

    if seen.include?(node_name) && !cycles_to_loop
      cycles_to_loop = cycle
    end

    seen << node_name

    break if cycles_to_z && cycles_to_loop

    node = nodes[next_node]

    cycle += 1
  end

  cycles_to_z - (cycles_to_loop - cycles_to_z)
  [cycles_to_z, (cycles_to_loop - cycles_to_z)]
  # cycles_to_loop + cycles_to_z
  # cycles_to_z + (cycles_to_loop - cycles_to_z)
  # [cycles_to_z , cycles_to_loop - 1]
end

puts loops.inspect

#2,931,935,407,171,185.
# puts "Part 2: #{cycle + 1}"
