input_file = ENV["TEST"] ? "example_input" : "input"

input = File.read(input_file).lines(chomp: true)

Monkey = Struct.new(
  :items,
  :operation,
  :test,
  :on_success,
  :on_failure,
  :inspections,
  keyword_init: true
)

zoo = []

input.slice_when { _1.empty? }.each.with_index do |monkey, index|
  zoo << Monkey.new(
    items: monkey[1].scan(/\d+/).map(&:to_i),
    operation: monkey[2].split("=").last.strip,
    test: monkey[3].scan(/\d+/).map(&:to_i).first,
    on_success: monkey[4].scan(/\d+/).map(&:to_i).first,
    on_failure: monkey[5].scan(/\d+/).map(&:to_i).first,
    inspections: 0
  )
end

def log(msg)
  puts msg if ENV["VERBOSE"]
end

play_round = ->(monkey) do
  until monkey.items.empty? do
    old = monkey.items.shift

    monkey.inspections += 1

    log "  Monkey inspects an item with a worry level of #{old}."
    worry = eval(monkey.operation)
    log "    Worry level is #{monkey.operation} to #{worry}."
    # worry = worry / 3
    # log "    Monkey gets bored with item. Worry level is divided by 3 to #{worry}."
    if worry % monkey.test == 0
      log "    Current worry level is divisible by #{monkey.test}."
      log "    Item with worry level #{worry} is thrown to monkey #{monkey.on_success}."
      zoo[monkey.on_success].items << worry

    else
      log "    Current worry level is not divisible by #{monkey.test}."
      log "    Item with worry level #{worry} is thrown to monkey #{monkey.on_failure}."
      zoo[monkey.on_failure].items << worry
    end
  end

end

90.times do |round|
  log "Round #{round}"
  zoo.each.with_index do |monkey, index|
    log "Monkey #{index}:"
    play_round.call(monkey)
  end
  zoo.each.with_index do |monkey, index|
    log "Monkey #{index}: #{monkey.items.join(", ")}"
  end
end


part1 = zoo.map(&:inspections).max(2).reduce(:*)
puts "Part 1: #{part1}"

pp zoo.flat_map(&:items)

nums =  zoo.flat_map(&:items)

res = nums.reduce(1) do |mem, var|
  mem = mem.gcd(var)
end
puts res
