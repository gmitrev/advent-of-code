require_relative '../../common'

input = read_input_lines.map { |l| l.chars.map(&:to_i) }

part_1 = input.map do |line|
  a, b = line

  max = "#{a}#{b}".to_i

  line[2..].each do |n|
    max = [max, "#{b}#{n}".to_i, "#{a}#{n}".to_i].max

    a, b = max.to_s.chars
  end

  max
end.sum

solve(1, part_1)

part_2 = input.map do |line|
  a, b, c, d, e, f, g, h, i, j, k, l = line

  max = [a, b, c, d, e, f, g, h, i, j, k, l].map(&:to_s).join.to_i

  # 💀💀💀💀💀
  line[12..].each do |n|
    max = [
      max,
      [b, c, d, e, f, g, h, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, c, d, e, f, g, h, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, d, e, f, g, h, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, e, f, g, h, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, f, g, h, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, e, g, h, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, e, f, h, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, e, f, g, i, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, e, f, g, h, j, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, e, f, g, h, i, k, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, e, f, g, h, i, j, l, n].map(&:to_s).join.to_i,
      [a, b, c, d, e, f, g, h, i, j, k, n].map(&:to_s).join.to_i
    ].max

    a, b, c, d, e, f, g, h, i, j, k, l = max.to_s.chars
  end

  max
end.sum

solve(1, part_2)
