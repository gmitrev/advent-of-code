input = File.read('input').each_line.map { |l| l.strip }

example = %w(BFFFBBFRRR FFFBBBFRRR BBFFBBFRLL)

all_seats = (0..127).to_a.product((0..7).to_a)

ids = []
input.each do |pass|
  rows = (0..127)
  row_symbols = pass.split('').take(7)

  row_symbols.each do |symbol|
    if symbol == 'F'
      rows, _ = rows.each_slice((rows.size/2.0).round).to_a
    elsif symbol == 'B'
      _, rows = rows.each_slice((rows.size/2.0).round).to_a
    end
  end

  row = rows.first

  cols = (0..7)
  col_symbols = pass.split('').last(3)

  col_symbols.each do |symbol|
    if symbol == 'L'
      cols, _ = cols.each_slice((cols.size/2.0).round).to_a
    elsif symbol == 'R'
      _, cols = cols.each_slice((cols.size/2.0).round).to_a
    end
  end

  col = cols.first

  seat_id = row * 8 + col
  ids << seat_id

  all_seats.delete([row, col])
end

puts "[Part 1] Max id: #{ids.max}"

# Part 2
missing = all_seats.reject { |s| s.first == 0 || s.first == 127  }

missing_ids = missing.map do |row, col|
  seat_id = row * 8 + col
end

missing_ids.sort.each_cons(3) do |a, b, c|
  if a != b - 1 && c != b + 1
    puts "[Part 2] Your seat ID: #{b}"
  end
end
