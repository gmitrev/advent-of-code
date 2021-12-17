require "set"

verbose = ENV["VERBOSE"]

input = File.read("input").lines(chomp: true).first

x1, x2, y1, y2 = input.scan(/-?\d+/).map(&:to_i)

puts "Target : #{x1}-#{x2} #{y1}-#{y2}" if verbose

hits = 0
top_ys = Set.new

draw = ->(probes) do
  min_y, max_y = probes.map { |x, y| y }.minmax
  max_x = [probes.map { |x, y| x }.max, x2].max + 2

  ([-max_y - 1, 0].min..([-min_y, -y1].max + 1)).each do |y|
    (0..max_x).each do |x|
      if x == 0 && y == 0
        print "S"
      elsif probes.member?([x, -y])
        print "#"
      elsif x >= x1 && x <= x2 && -y >= y1 && -y <= y2
        print "T"
      else
        print "."
      end
    end
    puts
  end
end

fire = ->(vx, vy) do
  probe = [0, 0]
  probes = Set.new

  until probe[0] > x2 || probe[1] < y1 || (vx == 0 && probe[0] < x1)
    probe[0] += vx
    probe[1] += vy

    if vx > 0
      vx -= 1
    elsif vx < 0
      vx += 1
    end

    vy -= 1

    if probe[0] >= x1 && probe[0] <= x2 && probe[1] >= y1 && probe[1] <= y2
      top_ys << probes.map(&:last).max if probes.any?
      hits += 1
      break
    end

    probes << probe.dup
  end

  draw.call(probes) if verbose
end

(0..250).each do |x|
  (-250..250).each do |y|
    fire.call(x, y)
  end
end

puts "Part 1: #{top_ys.max}"
puts "Part 2: #{hits}"
