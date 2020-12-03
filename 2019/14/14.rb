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

Reaction = Struct.new(:name, :input, :output) do
  def base?
    input.keys == ['ORE']
  end

  def kor(spellbook)
    res = reduce 1, spellbook
    pp res
    res.map do |a, n|
      mat = spellbook[a]
      mat.resolve(n)
    end.sum
  end

  def reduce(n, spellbook)
    op = {}

    input.each do |k, v|
      reagent = spellbook[k]

      if reagent.base?
        op[k] = op[k].to_i + v * v
      else
        reagent.reduce(n, spellbook).each do |kk, vv|
          op[kk] = op[kk].to_i + vv * vv
        end
      end
    end

    op
  end

  def resolve(n)
    needed = (n.to_f / output.to_f).ceil

    needed * output
  end
end

def run(input)
  spellbook = {}

  input.each_line do |line|
    reagents, result = line.split('=>').map(&:strip)

    output, sym = result.split(' ')

    input = reagents.split(',').map do |reagent|
      amount, symbol = reagent.strip.split(' ')
      [symbol, amount.to_i]
    end.to_h

    spellbook[sym] = Reaction.new(sym, input, output.to_i)
  end

  pp spellbook

  fuel = spellbook['FUEL']
  pp fuel.kor spellbook
end

# run example1
run example2
