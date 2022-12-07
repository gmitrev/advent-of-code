input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

class D
  attr_accessor :entries, :name, :parent

  def initialize(name, parent)
    @name = name
    @parent = parent
    @entries = []
  end

  def size
    @size ||= entries.sum(&:size)
  end

  def find(path)
    entries.find { |e| e.is_a?(D) && e.name == path }
  end

  def folders
    [self] + entries.select { |e| e.is_a?(D) }.map(&:folders)
  end
end

class F
  attr_accessor :name, :parent, :size

  def initialize(name, parent, size)
    @name = name
    @parent = parent
    @size = size.to_i
  end

  def path
    "#{@parent&.path}#{@name}/"
  end
end

root = current = nil

input.slice_before { |l| l.start_with?("$") }.each do |line|
  command, *output = line
  _, cmd, path = command.split(" ")

  case cmd
  when "cd"
    if path == ".."
      current = current.parent
    else
      current = current ? current.find(path) : D.new(path, nil)
      root ||= current
    end
  when "ls"
    output.each do |path|
      a, b = path.split(" ")

      if a == "dir"
        current.entries << D.new(b, current)
      else
        current.entries << F.new(b, current, a)
      end
    end
  end
end

part1 = root.folders.flatten.select { |f| f.size < 100_000 }.sum(&:size)
puts "Part 1: #{part1}"

needed = 30_000_000 - (70_000_000 - root.size)

part2 = root.folders.flatten.select { |f| f.size > needed }.map(&:size).min
puts "Part 2: #{part2}"
