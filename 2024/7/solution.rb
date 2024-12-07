require_relative '../../common.rb'

input = read_input
debug input
debug

structured = input.each_line.map do |l|
  test, numbers = l.split(':')
  numbers = numbers.split(' ').map(&:to_i)
  [test.to_i, numbers]
end

def dfs(test, queue, op, ops)
  return test == queue.first if queue.size == 1
  return false if queue.empty? || queue.first > test

  a, b, *rest = queue

  head = op == :add ? (a.to_s + b.to_s).to_i : a.send(op, b)

  ops.any? do |op|
    dfs(test, [head, *rest], op, ops)
  end
end

benchmark do
  ops = [:*, :+]

  part1 = structured.sum do |test, numbers|
    ops.any? do |op|
      dfs(test, numbers, op, ops)
    end ? test : 0
  end

  solve(1, part1)
end


benchmark do
  ops = [:*, :+, :add]

  part2 = structured.sum do |test, numbers|
    ops.any? do |op|
      dfs(test, numbers, op, ops)
    end ? test : 0
  end

  solve(2, part2)
end
