def debug(*)
  puts(*) if ENV['TEST'] == '1'
end

def answer(part, answer)
  puts "Part #{part}: #{answer}"
end

testing = ENV['TEST'] == '1'
input_file = testing ? "example_input" : "input"

input = File.read(input_file)

debug input

list = input.lines(chomp: true).map { |line| line.chars }

transposed = list.transpose

XMAS = 'XMAS'

matches = 0
list.each_with_index do |line, y|
  line.each_with_index do |col, x|
    next unless col == 'X'

    # check right
    right = line[x..(x+3)]
    matches += 1 if right.join == XMAS

    # check left
    left = line[(x-3)..x]
    matches += 1 if left.join == XMAS.reverse

    # check diagonals
    [[-1,-1], [-1, 1], [1, -1], [1,1]].each do |dx, dy|
      diagonal = 4.times.map { |i| [dx * i, dy * i] }
      diagonal = diagonal.map { |a, b| [x + a, y + b] }
      diagonal = diagonal.map do |a, b|
        next  if a < 0 || b < 0

        list[b][a] if list[b]
      end

      matches += 1 if diagonal.join == XMAS
    end
  end
end

transposed.each_with_index do |line, y|
  line.each_with_index do |col, x|
    next unless col == 'X'

    top = line[x..(x+3)]
    matches += 1 if top.join == XMAS

    bottom = line[(x-3)..x]
    matches += 1 if bottom.join == XMAS.reverse
  end
end

debug if testing
answer(1, matches)

MAS = ['MAS', 'SAM']

matches = 0

list.each_with_index do |line, y|
  line.each_with_index do |col, x|
    next unless col == 'A'

    # check diagonals
    top_left =     [x-1, y-1]
    top_right =    [x+1, y-1]
    bottom_left =  [x-1, y+1]
    bottom_right = [x+1, y+1]

    next if [top_left, top_right, bottom_left, bottom_right].flatten.any? { |n| n < 0 }

    diag1 = list.dig(top_left[1], top_left[0]).to_s + 'A' + list.dig(bottom_right[1], bottom_right[0]).to_s
    diag2 = list.dig(bottom_left[1], bottom_left[0]).to_s + 'A' + list.dig(top_right[1], top_right[0]).to_s


    matches += 1 if MAS.include?(diag1) && MAS.include?(diag2)
  end
end

answer(2, matches)
