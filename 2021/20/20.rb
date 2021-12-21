verbose = ENV["VERBOSE"]

input = File.read("input").lines(chomp: true)
algo = input.first
image = input[2..].map(&:chars)

default = proc { "." }

OFFSET = 1
MASK_POSITIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]
MASK_MAP = {"." => 0, "#" => 1}

pixels = {}

image.size.times do |y|
  pixels[y] ||= {}
  image[0].size.times do |x|
    pixels[y][x] = image.dig(y, x) || default
  end
end

def draw(pixels)
  min_y, max_y = pixels.keys.minmax
  min_x, max_x = pixels.values.flat_map(&:keys).minmax

  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      pixel =
        if pixels[y][x].is_a?(Proc)
          pixels[y][x].call
        else
          pixels[y][x]
        end

      print pixel
    end
    puts
  end

  puts
end

enhance_pixel = ->(template, y, x) do
  position = MASK_POSITIONS.map do |yy, xx|
    mask = template.dig(y + yy, x + xx) || default

    mask = if mask.is_a?(Proc)
      mask.call
    else
      mask
    end

    MASK_MAP[mask]
  end.join.to_i(2)

  algo[position]
end

enhance_image = -> do
  min_y, max_y = pixels.keys.minmax
  min_x, max_x = pixels.values.flat_map(&:keys).minmax

  tmp = {}

  ((min_y - OFFSET)..(max_y + OFFSET)).each do |y|
    tmp[y] ||= {}
    ((min_x - OFFSET)..(max_x + OFFSET)).each do |x|
      tmp[y][x] = enhance_pixel.call(pixels, y, x)
    end
  end

  pixels = tmp
  draw(pixels) if verbose
end

# 2.times do |i|
50.times do |i|
  enhance_image.call
  default = proc { (i + 1).even? ? "." : "#" }
end

puts "Part 2: " + pixels.values.flat_map(&:values).count { |c| c == "#" }.to_s
