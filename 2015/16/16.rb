input = File.read("input").strip.each_line.map(&:strip)

criteria =
  {
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
  }

input.each do |line|
  aunt, *properties = line.split(": ")
  properties = properties.flat_map { |p| p.split(", ") }.each_slice(2).to_a.to_h

  if properties.all? { |k, v| criteria[k] == v.to_i }
    puts "Part 1: #{aunt}"
  end

  match =
    properties.all? do |k, v|
      case k
      when "cats", "trees"
        criteria[k] < v.to_i
      when "pomeranians", "goldfish"
        criteria[k] > v.to_i
      else
        criteria[k] == v.to_i
      end
    end

  puts "Part 2: #{aunt}" if match
end
