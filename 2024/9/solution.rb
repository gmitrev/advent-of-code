require_relative '../../common.rb'

input = read_input.strip
debug input

benchmark do
  id = 0

  disk = input.chars.map.with_index do |char, i|
    if i.even?
      block = [id] * char.to_i
      id += 1
      block
    else
      ('.' * char.to_i).chars
    end
  end.flatten

  a = 0
  b = disk.size - 1

  debug disk.join
  while b > a
    # if b is a file and a is a dot, swap them
    if disk[b] != '.' && disk[a] == '.' && b > a
      disk[a] = disk[b]
      disk[b] = '.'
      # debug disk.join
    end

    a += 1 if disk[a] != '.'
    b -= 1 if disk[b] == '.'
  end

  part1 = disk.map(&:to_i).map.with_index do |n, i|
    n * i
  end.sum

  solve(1, part1)
end

benchmark do
  Файл = Struct.new(:id, :size) do
    def inspect
      to_s.join
    end

    def join
      self
    end

    def to_s
      [id] * size
    end
  end

  Void = Struct.new(:size) do
    def inspect
      to_s.join
    end

    def join
      self
    end

    def to_s
      (['.'] * size)
    end
  end

  id = 0
  files = []

  disk = input.chars.map.with_index do |char, i|
    if i.even?
      file = Файл.new(id, char.to_i)
      id += 1
      files << file
      file
    else
      Void.new(char.to_i) if char.to_i > 0
    end
  end.compact

  debug disk.map(&:to_s).join

  files.reverse.each do |file|
    free_space = disk.index do |item|
      next if item.is_a?(Файл)

      item.size >= file.size
    end

    if free_space
      file_index = disk.index { |item| item == file }

      file = disk[file_index]

      # Do not move files to the right
      next if file_index < free_space

      # Release space
      before = disk[file_index - 1]
      after = disk[file_index + 1]

      if(before.is_a?(Void) && after.is_a?(Void))
        # merge 3 voids
        megavoid = Void.new(before.size + after.size + file.size)
        disk.delete_at(file_index + 1)
        disk.delete_at(file_index)
        disk[file_index-1] = megavoid
      elsif(before.is_a?(Void))
        before.size += file.size
        disk.delete_at(file_index)
      elsif(after.is_a?(Void))
        after.size += file.size
        disk.delete_at(file_index)
      else
        disk[file_index] = Void.new(file.size)
      end

      void = disk[free_space]
      void.size -= file.size if void.size >= file.size
      disk.insert(free_space, file)
    end
    debug disk.map(&:to_s).join
  end

  part2 = disk.map(&:to_s).flatten.map.with_index do |n, i|
    n.to_i * i
  end.sum

  solve(2, part2)
end
