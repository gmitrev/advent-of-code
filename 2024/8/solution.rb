require_relative '../../common.rb'

input = read_input_lines

chars = Hash.new { |k, v| k[v] = [] }
maxy = maxx = 0

map = input.map.with_index do |l, y|
  maxy = l.size
  maxx = l.chars.size

  l.chars.map.with_index do |c, x|
    chars[c] << [y, x] if c != '.'

    c
  end
end

xrange = (0...maxx)
yrange = (0...maxy)

chars.each do |c, positions|
  positions.combination(2).to_a.each do |a, b|
    dx = b[1] - a[1]
    dy = b[0] - a[0]

    ay = a[0] - dy
    ax = a[1] - dx

    by = b[0] + dy
    bx = b[1] + dx

    map[ay][ax] = '#' if yrange.include?(ay) && xrange.include?(ax)
    map[by][bx] = '#' if yrange.include?(by) && xrange.include?(bx)
  end
end

debug
debug map.map(&:join).join("\n")
debug

part1 = map.flatten.count { |x| x == '#' }
solve(1, part1)

chars.each do |c, positions|
  positions.combination(2).to_a.each do |a, b|
    dx = b[1] - a[1]
    dy = b[0] - a[0]

    ay = a[0]
    ax = a[1]
    by = b[0]
    bx = b[1]

    while bx <= maxx && by <= maxy
      by = by + dy
      bx = bx + dx

      map[by][bx] = '#' if yrange.include?(by) && xrange.include?(bx)
    end

    while ay >= 0 && ax >= 0
      ay = ay - dy
      ax = ax - dx

      map[ay][ax] = '#' if yrange.include?(ay) && xrange.include?(ax)
    end
  end
end

debug
debug map.map(&:join).join("\n")
debug

part2 = map.flatten.count { |x| x != '.' }
solve(2, part2)
