REGEXP = Regexp.new(/^(?<i1>[a-z]{1,2}|\d*)?\s?(?<op>NOT|OR|AND|RSHIFT|LSHIFT)?\s?(?<i2>[a-z]{1,2}|\d*)? -> (?<o>\w{1,2})$/)

# input = File.read("example_input").strip
input = File.read("input").strip

wires = {}
cache = {}

input.each_line do |line|
  parsed = line.strip.match REGEXP

  input1, gate, input2, output = parsed.captures

  wires[output] = [input1, gate, input2]
end

resolve = ->(wire) {
  if wire.match?(/^\d*$/)
    wire.to_i
  else
    if cache[wire]
      puts "Resolving #{wire} from cache: #{cache[wire]}"

      return cache[wire]
    else
      puts "Resolving #{wire} => #{wires[wire]}"
    end

    input1, gate, input2 = wires[wire]

    value =
      case gate
      when nil
        resolve.call(input1)
      when "NOT"
        65535 - resolve.call(input2)
      when "AND"
        resolve.call(input1) & resolve.call(input2)
      when "OR"
        resolve.call(input1) | resolve.call(input2)
      when "LSHIFT"
        resolve.call(input1) << resolve.call(input2)
      when "RSHIFT"
        resolve.call(input1) >> resolve.call(input2)
      end

    puts "Resolved: #{wire} => #{value}"
    cache[wire] = value

    value
  end
}

puts "Part 1: #{resolve.call("a")}"
# => 3176

# Part 2
cache = {}
wires["b"] = ["3176", nil, ""]

puts "Part 2: #{resolve.call("a")}"
