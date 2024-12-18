require 'benchmark'
require 'rainbow'

FULL_BLOCK = '█'

def debug(*)
  puts(*) if test?
end

def test?
  ENV['TEST'] == '1'
end

def d(*)
  debug(*)
end

def i(what)
  puts(what.inspect) if test?
end

def solve(part, answer)
  puts "Part #{part}: #{answer}"
end

def read_input
  input_file = test? ? 'example_input' : 'input'
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
