example1 = <<~END
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
END

example2 = <<~END
9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL
END

example3 = <<~END
157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
END

spellbook = {}
basics = []

example2.each_line do |line|
  reagents, result = line.split('=>').map(&:strip)

  output, sym = result.split(' ')

  input = reagents.split(',').map do |reagent|
    amount, symbol = reagent.strip.split(' ')
    [symbol, amount.to_i]
  end.to_h

  basics << sym if input.keys == ['ORE']
  spellbook[sym] = {n: sym, input: input, output: output.to_i, base: input.keys == ['ORE']}
end

need = {'FUEL' => 1}

while need.keys.sort != basics.keys.sort
  put
pp spellbook
