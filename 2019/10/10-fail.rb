original_input = File.read('10-input').strip

example1 = <<END
.#..#
.....
#####
....#
...##
END

example1 = <<END
#.........
...A......
...B..a...
.EDCG....a
..F.c.b...
.....c....
..efd.c.gb
.......c..
....f...c.
...e..d..c
END

def normalize(input)
  input.each_line.map do |line|
    line.strip.split('').map { |c| c == '.' ? nil : c}
  end
end

map1 = normalize example1

def los(map, x, y)
  max_x = map.first.size - 1
  max_y = map.size - 1

  vectors = (0..max_x).to_a.flat_map { |x| (0..max_y).map { |y| [x, y] }}.select { |a| a.include?(0) || a.include?(max_y) }


  if x == 0
    vectors.reject! { |v| v[0] == 0 && v[1] != max_y && v[1] != 0 }
  end

  if x == max_x
    vectors.reject! { |v| v[0] == max_x && v[1] != max_y && v[1] != 0 }
  end

  if y == 0
    vectors.reject! { |v| v[1] == 0 && v[0] != max_x && v[0] != 0  }
  end

  if y == max_y
    vectors.reject! { |v| v[1] == max_y && v[0] != max_x && v[0] != 0  }
  end

  # puts map[y][x]
  in_los = 0
  vectors.each do |vector|
    cur = [x, y]
    if cur[0] > vector[0] && cur[1] > vector[1]
      # ↖
      bases = [cur[0] - vector[0], cur[1] - vector[1]]
      gcd = bases.min.gcd(bases.max)
      steps = [bases[0] / gcd, bases[1] / gcd]
      pp "Pos: #{cur} Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"
      steps_x = (vector[0]..cur[0]).step(steps[0])
      steps_y = (vector[1]..cur[1]).step(steps[1])

      to_visit = steps_x.to_a.zip(steps_y.to_a)[0..-2]
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    elsif cur[0] < vector[0] && cur[1] < vector[1]
      # ↘
      bases = [vector[0] - cur[0], vector[1] - cur[1]]
      gcd = bases.min.abs.gcd(bases.max.abs)
      steps = [bases[0].abs / gcd, bases[1].abs / gcd]
      pp "Pos: [#{x}, #{y}] Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"
      steps_x = (cur[0]..vector[0]).step(steps[0])
      steps_y = (cur[1]..vector[1]).step(steps[1])

      to_visit = steps_x.to_a[1..-1].zip(steps_y.to_a[1..-1])
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    elsif cur[0] > vector[0] && cur[1] == vector[1]
      # ←
      bases = [vector[0] - cur[0], vector[1] - cur[1]]
      gcd = bases.min.abs.gcd(bases.max.abs)
      steps = [bases[0].abs / gcd, bases[1].abs / gcd]
      pp "Pos: [#{x}, #{y}] Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"

      steps_x = (vector[0]..cur[0]).step(steps[0])
      steps_y = [vector[1]] * (cur[0] - vector[0] + 1)

      to_visit = steps_x.to_a[0..-2].zip(steps_y.to_a[0..-2])
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    elsif cur[0] < vector[0] && cur[1] == vector[1]
      # →
      bases = [vector[0] - cur[0], vector[1] - cur[1]]
      gcd = bases.min.abs.gcd(bases.max.abs)
      steps = [bases[0].abs / gcd, bases[1].abs / gcd]
      pp "Pos: [#{x}, #{y}] Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"

      steps_x = (cur[0]..vector[0]).step(steps[0])
      steps_y = [cur[1]] * (vector[0] - cur[0] + 1)

      to_visit = steps_x.to_a[1..-1].zip(steps_y.to_a[1..-1])
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    elsif cur[0] == vector[0] && cur[1] > vector[1]
      # ↑
      bases = [vector[0] - cur[0], vector[1] - cur[1]]
      gcd = bases.min.abs.gcd(bases.max.abs)
      steps = [bases[0].abs / gcd, bases[1].abs / gcd]
      pp "Pos: [#{x}, #{y}] Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"

      steps_x = [cur[0]] * (cur[1] - vector[1] + 1)
      steps_y = (vector[1]..cur[1]).step(steps[1])

      to_visit = steps_x.to_a[0..-2].zip(steps_y.to_a[0..-2])
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    elsif cur[0] == vector[0] && cur[1] < vector[1]
      # ↓
      bases = [vector[0] - cur[0], vector[1] - cur[1]]
      gcd = bases.min.abs.gcd(bases.max.abs)
      steps = [bases[0].abs / gcd, bases[1].abs / gcd]
      pp "Pos: [#{x}, #{y}] Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"

      steps_x = [cur[0]] * (vector[1] - cur[1] + 1)
      steps_y = (cur[1]..vector[1]).step(steps[1])

      to_visit = steps_x.to_a[1..-1].zip(steps_y.to_a[1..-1])
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    elsif cur[0] < vector[0] && cur[1] > vector[1]
      # ↗
      bases = [cur[0] - vector[0], cur[1] - vector[1]]
      gcd = bases.min.gcd(bases.max)
      steps = [bases[0] / gcd, bases[1] / gcd]
      pp "Pos: #{cur} Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"
      steps_x = (cur[0]..vector[0]).step(steps[0].abs).to_a.reverse
      steps_y = (vector[1]..cur[1]).step(steps[1])

      to_visit = steps_x.to_a.zip(steps_y.to_a)[0..-2]
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    elsif cur[0] > vector[0] && cur[1] < vector[1]
      # ↙
      bases = [cur[0] - vector[0], cur[1] - vector[1]]
      gcd = bases.min.gcd(bases.max)
      steps = [bases[0] / gcd, bases[1] / gcd]
      pp "Pos: #{cur} Vector: #{vector}; bases: #{bases} GCD: #{gcd} Steps: #{steps}"

      steps_x = (vector[0]..cur[0]).step(steps[0].abs)
      steps_y = (cur[1]..vector[1]).step(steps[1].abs).to_a.reverse

      to_visit = steps_x.to_a.zip(steps_y.to_a)[0..-2]
      pp "to_visit: #{to_visit}"
      if to_visit.any? { |r| map[r[1]][r[0]] }
        in_los +=1
        puts 'yess!'
      end
    end

  end
  pp in_los
  in_los
end

# los map1, 4, 4, [[2, 2]]
# los map1, 4, 4, [[0, 2]]
# los map1, 9, 6, [[0,0]]
#
# los map1, 2, 2, [[4, 4]]
# los map1, 0, 2, [[4, 4]]
#
# los map1, 4, 0, [[0,0]]
# los map1, 4, 2, [[2,2]]

# los map1, 0, 0, [[4,0]]

# los map1, 0, 4, [[0,0]]

# los map1, 0, 0, [[0,4]]

# los map1, 2, 2, [[4,0]]

# los map1, 2, 2, [[0,4]]
#
# los map1, 1, 0, [[4,0]]
# los map1, 4, 0, [[4,4]]

# los map1, 1, 0, vectors
# los map1, 4, 0, vectors
#
los map1, 0, 0
