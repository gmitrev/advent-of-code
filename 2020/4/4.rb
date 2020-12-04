input = File.read('input').each_line.map { |l| l.strip }

# Part 1
valid = 0
current_keys = []
required_keys = %w(byr iyr eyr hgt hcl ecl pid)

input.each do |line|
  if line.empty?
    # Check for validity
    valid += 1 if (required_keys - current_keys).empty?
    current_keys = []
  else
    line.split(' ').each do |pair|
      key, _value = pair.split(':')
      current_keys << key
    end
  end
end

# don't forget final line
valid += 1 if (required_keys - current_keys).empty?

puts "[Part 1] Valid: #{valid}"

# Part 2
valid = 0
current_passport = {}

def valid?(passport)
  required_keys = %w(byr iyr eyr hgt hcl ecl pid)

  # Check required fields
  return false unless (required_keys - passport.keys).empty?

  # Birth year
  return false unless (1920..2002).include? passport['byr'].to_i

  # Issue year
  return false unless (2010..2020).include? passport['iyr'].to_i

  # Expiration year
  return false unless (2020..2030).include? passport['eyr'].to_i

  # Eye color
  return false unless %w(amb blu brn gry grn hzl oth).include? passport['ecl']

  # Passport ID
  return false unless passport['pid'].size == 9 && passport['pid'] =~ %r{\d*}

  # Height
  height = passport['hgt'].match(%r{(?<value>\d*)(?<unit>(cm|in))})

  return false unless height

  if height['unit'] == 'cm'
    return false unless (150..193).include? height['value'].to_i
  elsif height['unit'] == 'in'
    return false unless (59..76).include? height['value'].to_i
  end

  # Hair color
  return false unless passport['hcl'] =~ %r{#([a-f0-9]{6})}

  true
end

input.each do |line|
  if line.empty?
    valid += 1 if valid? current_passport
    current_passport = {}
  else
    line.split(' ').each do |pair|
      key, value = pair.split(':')
      current_passport[key] = value
    end
  end
end

# don't forget final line
valid += 1 if valid? current_passport

puts "[Part 2] Valid: #{valid}"
