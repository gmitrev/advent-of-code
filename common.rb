require 'benchmark'

def debug(*)
  puts(*) if ENV['TEST'] == '1'
end

def i(what)
  puts(what.inspect) if ENV['TEST'] == '1'
end

def solve(part, answer)
  puts "Part #{part}: #{answer}"
end

def read_input
  input_file = ENV['TEST'] == '1' ? "example_input" : "input"
  File.read(input_file)
end

def read_input_lines
  read_input.lines(chomp: true)
end

def benchmark
  res =
    Benchmark.realtime do
      yield
    end

  puts "took #{"%.2f" % (res * 1000).round(2)}ms\n\n"
end
