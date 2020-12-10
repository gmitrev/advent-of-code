input = File.read('input').each_line.map { |l| l.strip.to_i }

preamble = 25

sums = {}
answer = nil

input.each_with_index do |n, i|
  if i >= preamble
    unless sums.values.flatten.include? n
      answer = n
      puts "[Part 1]: #{answer}"
      break
    end
  end

  others = input[[0, i-preamble].max..[0, i-1].max] - [n]

  sums[n] = []
  others.each { |o| sums[n] << n + o  }

  sums.delete(input[i-preamble]) if i >= preamble
end

# Part 2
input.each_with_index do |n, i|
  sum = n
  offset = 1

  chain = []

  loop do
    next_number = input[i + offset]
    break unless next_number
    # puts "Next number: ##{i + offset}, #{next_number}"

    chain << next_number

    if chain.sum == answer && chain.size > 1
      puts "[Part 2] OMFG: #{chain.min} + ... + #{chain.max} = #{chain.min + chain.max}"
    elsif chain.sum > answer
      # puts "Sum #{sum} is getting larger than #{answer}, bailing..."
      break
    end

    offset += 1
  end
end
