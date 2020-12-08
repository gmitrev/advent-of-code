input = File.read('input').each_line.map { |l| l.strip }

class VirtualMachine
  class Finished < StandardError; end
  class EndlessLoopDetected < StandardError; end

  def initialize(instructions)
    @instructions = instructions
    @line = 0
    @acc = 0
  end

  def step
    instruction = @instructions[@line]

    raise Finished if instruction.nil?
    raise EndlessLoopDetected if instruction[:visited]

    instruction[:visited] = true

    case instruction[:op]
    when 'nop'
      @line += 1
    when 'acc'
      @acc += instruction[:arg]
      @line += 1
    when 'jmp'
      @line += instruction[:arg]
    end
  end

  def run(log_endless_loop: true)
    loop do
      step
    rescue EndlessLoopDetected => e
      pp "Endless loop detected, @acc is #{@acc}" if log_endless_loop
      break
    rescue Finished => e
      pp "Finished, @acc is #{@acc}"
      break
    end
  end
end

@instructions = input.map do |i|
  op, arg = i.split(' ')

  {op: op, arg: arg.to_i, visited: false}
end

machine = VirtualMachine.new Marshal.load(Marshal.dump(@instructions))
machine.run

@instructions.each_with_index do |instruction, index|
  if instruction[:op] == 'jmp'
    begin
      @instructions[index][:op] = 'nop'

      machine = VirtualMachine.new Marshal.load(Marshal.dump(@instructions))
      machine.run log_endless_loop: false
    ensure
      @instructions[index][:op] = 'jmp'
    end
  elsif instruction[:op] == 'nop'
    begin
      @instructions[index][:op] = 'jmp'

      machine = VirtualMachine.new Marshal.load(Marshal.dump(@instructions))
      machine.run log_endless_loop: false
    ensure
      @instructions[index][:op] = 'nop'
    end
  end
end
