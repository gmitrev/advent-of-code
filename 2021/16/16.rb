input = File.read("input").lines(chomp: true).first
input = input.chars.map { |c| c.to_i(16).to_s(2).rjust(4, "0") }.join

class Packet
  attr_reader :length

  def initialize(bits)
    @bits = bits
    @length = nil
    @result = nil
    @version = @bits[0...3].to_i(2)
    @type_id = @bits[3...6].to_i(2)
  end

  def evaluate
    case @type_id
    when 0
      @result.sum(&:evaluate)
    when 1
      @result.map(&:evaluate).reduce(:*)
    when 2
      @result.map(&:evaluate).min
    when 3
      @result.map(&:evaluate).max
    when 4
      @result
    when 5
      @result.map(&:evaluate).then { |a, b| a > b ? 1 : 0 }
    when 6
      @result.map(&:evaluate).then { |a, b| a < b ? 1 : 0 }
    when 7
      @result.map(&:evaluate).then { |a, b| a == b ? 1 : 0 }
    end
  end

  def versions
    if @result.is_a?(Array)
      @version + @result.sum(&:versions)
    else
      @version
    end
  end

  def remaining_bits
    @bits[@length..] if @length && @bits.size != @length
  end

  def unwrap
    if @type_id == 4
      unrwap_literal
    else
      unrwap_operator
    end

    self
  end

  private

  def unrwap_literal
    number = []
    start = 6

    loop do
      num = @bits[start..(start + 4)]

      prefix, *num = num.chars
      number << num.join

      start += 5

      break if prefix == "0"
    end

    @length = start

    @result = number.join.to_i(2)
  end

  def unrwap_operator
    offset = 7

    if @bits[6] == "0"
      subpacket_length = @bits[offset...(offset + 15)].to_i(2)
      subpackets = @bits[(offset + 15)...(offset + 15 + subpacket_length)]

      @result = consume(subpackets)

      @length = 15 + offset + subpacket_length
    else
      subpacket_length = @bits[offset...(offset + 11)].to_i(2)
      subpackets = @bits[(offset + 11)..]

      @result = consume(subpackets, limit: subpacket_length)

      @length = offset + 11 + @result.sum(&:length)
    end
  end

  def consume(bits, limit: nil)
    packets = []

    packet = Packet.new(bits).unwrap
    packets << packet

    until packet.remaining_bits.nil? || packets.size == limit
      packet = Packet.new(packet.remaining_bits).unwrap
      packets << packet
    end

    packets
  end
end

p = Packet.new(input).unwrap

puts "Part 1: #{p.versions}"
puts "Part 2: #{p.evaluate}"
