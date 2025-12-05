require_relative '../../common'

input = read_input_lines.map { |l| l.split('') }

NEIGHBORS = [-1,0,1].permutation(2).to_a + [[1,1], [-1,-1]]

VOID = Struct.new do
  def inspect = '.'
end.new

Roll = Struct.new(:x, :y) do
  def inspect
    neighbors.count < 4 ? 'x' : '@'
  end

  def neighbors
    NEIGHBORS.map do |dx, dy|
      xx = x + dx
      yy = y + dy

      if yy >= 0 && xx >= 0
        MAP.dig(yy, xx)
      end
    end.compact.select { |item| item.is_a?(Roll) }
  end
end

rolls = []

MAP =
  input.map.with_index do |row, y|
    row.map.with_index do |col, x|
      if col == '@'
        roll = Roll.new(x, y)
        rolls << roll
        roll
      else
        VOID
      end
    end
  end

MAP.each do |line|
  d line.inspect
end

solve(1, rolls.count { |r| r.neighbors.count < 4 })

total_removed = 0

loop do
  to_remove = rolls.select { |r| r.neighbors.count < 4 }

  break if to_remove.empty?

  to_remove.each do |roll|
    total_removed += 1

    rolls.delete(roll)
    MAP[roll.y][roll.x] = VOID
  end

end

solve(2, total_removed)
