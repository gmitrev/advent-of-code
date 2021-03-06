require 'logger'

class IntcodeRunner
  attr_reader :output

  def initialize(instructions, inputs=[], debug: false)
    @instructions = instructions.dup
    @inputs = inputs
    @operator_position = 0
    @relative_base = 0
    @output = []
    @stop = false
    @halted = false
    @debug = debug
    @log_level = debug ? Logger::DEBUG : Logger::INFO
  end

  class << self
    def run(*options)
      new(*options).run
    end
  end

  def halted?
    !!@halted
  end

  def feed_input(input)
    @inputs << input
  end

  def start
    @stop = false
    @halted = false
    run
  end

  def run
    until @stop do
      logger.debug '=' * 40
      opcode = @instructions[@operator_position]
      logger.debug "##{@operator_position} with opcode: #{opcode}"

      code_1 = ->(a, b, target) {
        sum = a + b
        logger.debug "writing sum of #{a}+#{b} #{sum} to ##{target}"
        @instructions[target] = sum
        advance(4)
      }

      code_2 = ->(a, b, target) {
        product = a * b
        logger.debug "writing product #{a}*#{b} #{product} to ##{target}"
        @instructions[target] = product
        advance(4)
      }

      code_3 = ->(mode) {
        address =
          case mode
          when 0
            @instructions[@operator_position + 1]
          when 1
            raise 'WAT??!?!?!'
          when 2
            @relative_base + @instructions[@operator_position + 1] || 0
          end

        logger.debug "writing #{@inputs.inspect}{1} to ##{address}"
        @instructions[address] = @inputs.shift
        advance(2)
      }

      code_4 = ->(val) {
        @output << val
        # @stop = true

        logger.debug "output: #{val}"
        advance(2)
      }

      code_5 = ->(a, b) {
        logger.debug "Comparing #{a} != #{0}"
        if a != 0
          logger.debug "Setting position to #{b}"
          set_position(b)
        else
          logger.debug "Advancing by 3"
          advance(3)
        end
      }

      code_6 = ->(a, b) {
        logger.debug "Comparing #{a} == #{0}"
        if a == 0
          logger.debug "Setting position to #{b}"
          set_position(b)
        else
          logger.debug "Advancing by 3"
          advance(3)
        end
      }

      code_7 = ->(a, b, t) {
        logger.debug "Comparing if #{a} < #{b}"
        if a < b
          logger.debug "Setting #{t} to 1"
          @instructions[t] = 1
        else
          logger.debug "Setting #{t} to 0"
          @instructions[t] = 0
        end

        logger.debug "Advancing by 4"
        advance(4)
      }

      code_8 = ->(a, b, t) {
        logger.debug "Comparing if #{a} == #{b}"
        if a == b
          logger.debug "Setting #{t} to 1"
          @instructions[t] = 1
        else
          logger.debug "Setting #{t} to 0"
          @instructions[t] = 0
        end
        logger.debug "Advancing by 4"
        advance(4)
      }

      code_9 = ->(a) {
        @relative_base += a
        logger.debug "Changing relative base by #{a} to #{@relative_base}"
        advance(2)
      }

      code_big = ->() {
        new_opcode, _, *modes = opcode.digits
        logger.debug "Opcode: #{new_opcode}"
        logger.debug "Modes: #{modes}"
        mode_a, mode_b, mode_t = modes
        logger.debug "mode_a: #{mode_a}, mode_b: #{mode_b}, mode_t: #{mode_t}"

        a =
          case mode_a.to_i
          when 0
            get_parameter(@operator_position, 1)
          when 1
            get_immediate(@operator_position, 1)
          when 2
            get_relative(@operator_position, 1)
          end

        b =
          case mode_b.to_i
          when 0
            get_parameter(@operator_position, 2)
          when 1
            get_immediate(@operator_position, 2)
          when 2
            get_relative(@operator_position, 2)
          end

        t =
          case mode_t.to_i
          when 0
            get_parameter(@operator_position, 3)
          when 1
            raise 'KO?!>!?'
          when 2
            @relative_base + @instructions[@operator_position + 3] || 0
          end

        logger.debug "a: #{a}; b: #{b}; t: #{t}"

        case new_opcode
        when 1
          code_1.(a, b, t)
        when 2
          code_2.(a, b, t)
        when 3
          code_3.(mode_a)
        when 4
          code_4.(a)
        when 5
          code_5.(a, b)
        when 6
          code_6.(a, b)
        when 7
          code_7.(a, b, t)
        when 8
          code_8.(a, b, t)
        when 9
          value = get_immediate(@operator_position, 1)
          code_9.(value)
        when 99
          @halted = true
          break
        else
          logger.debug "OUTPUT: #{@output}"

          dump
          raise "MEGA KOR: unexpected opcode #{new_opcode}"
        end
      }

      case opcode
      when 1
        a = get_parameter(@operator_position, 1)
        b = get_parameter(@operator_position, 2)
        target = get_immediate(@operator_position, 3)
        code_1.(a, b, target)
      when 2
        a = get_parameter(@operator_position, 1)
        b = get_parameter(@operator_position, 2)
        target = get_immediate(@operator_position, 3)
        code_2.(a, b, target)
      when 3
        # address = get_immediate(@operator_position, 1)
        code_3.(0)
      when 4
        value = get_parameter(@operator_position, 1)
        code_4.(value)
      when 5
        a = get_parameter(@operator_position, 1)
        b = get_parameter(@operator_position, 2)
        code_5.(a, b)
      when 6
        a = get_parameter(@operator_position, 1)
        b = get_parameter(@operator_position, 2)
        code_6.(a, b)
      when 7
        a = get_parameter(@operator_position, 1)
        b = get_parameter(@operator_position, 2)
        t = get_immediate(@operator_position, 3)
        code_7.(a, b, t)
      when 8
        a = get_parameter(@operator_position, 1)
        b = get_parameter(@operator_position, 2)
        t = get_immediate(@operator_position, 3)
        code_8.(a, b, t)
      when 9
        value = get_immediate(@operator_position, 1)
        code_9.(value)
      when 99
        @halted = true
        break
      else
        code_big.()
      end
    end

    dump if @debug
    @output
  end

  private

  def advance(with)
    @operator_position += with
  end

  def set_position(to)
    @operator_position = to
  end

  def get_parameter(position, offset)
    @instructions[@instructions[position + offset]] || 0
  end

  def get_immediate(position, offset)
    @instructions[position + offset] || 0
  end

  def get_relative(position, offset)
    @instructions[@relative_base + @instructions[position + offset]] || 0
  end

  def dump(size: 250)
    @instructions.take(size).each_with_index do |i, position|
      logger.info "#{position}: #{i}"
    end
  end

  def logger
    @logger ||=
      begin
        logger = Logger.new(STDOUT)
        logger.level = @log_level
        logger.formatter = ->(_severity, _datetime, _progname, msg) { "#{msg}\n" }
        logger
      end
  end
end
