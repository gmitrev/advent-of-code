require "set"
verbose = ENV["VERBOSE"]

input = File.read("input").each_line.map(&:strip)

edges = {}

input.each do |line|
  a, b = line.split("-")

  edges[a] ||= []
  edges[b] ||= []

  edges[a] << b unless b == "start"
  edges[b] << a unless a == "start"
end

paths = []

traverse = ->(node, visited = []) do
  if node == "end"
    paths << visited + ["end"]
    return
  end

  edges[node].each do |edge|
    next if edge.downcase == edge && visited.include?(edge)
    traverse.call(edge, visited.dup << node)
  end
end

traverse.call("start")

pp paths.map { |path| path.join(" -> ") }.sort if verbose

puts "Part 1: #{paths.count}"

paths = []

traverse = ->(node, visited = [], visited_small = false) do
  if node == "end"
    paths << visited + ["end"]
    return
  end

  edges[node].each do |edge|
    if visited.include?(edge) && edge.downcase == edge
      next if visited_small

      traverse.call(edge, visited.dup << node, true)
    else
      traverse.call(edge, visited.dup << node, visited_small)
    end
  end
end

traverse.call("start")

pp paths.map { |path| path.join(" -> ") }.sort if verbose

puts "Part 2: #{paths.count}"
