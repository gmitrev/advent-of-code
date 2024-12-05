require 'benchmark'

def debug(*)
  puts(*) if ENV['TEST'] == '1'
end

def solve(part, answer)
  puts "Part #{part}: #{answer}"
end

def read_input
  input_file = ENV['TEST'] == '1' ? "example_input" : "input"
  File.read(input_file)
end

def benchmark
  res =
    Benchmark.realtime do
      yield
    end

  puts "took #{res.round(5)}s\n\n"
end
