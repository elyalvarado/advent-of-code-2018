def normalize_elf_position position, array_size
  position > array_size - 1 ? normalize_elf_position(position - array_size, array_size) : position
end

def print_scoreboard first_elf_position, second_elf_position, scoreboard
  printable = scoreboard.map(&:to_s)
  printable[first_elf_position] = "(#{printable[first_elf_position]})"
  printable[second_elf_position] = "[#{printable[second_elf_position]}]"
  puts printable.join(" ")
end

# ruby day14/ten_recipes_after.rb  6.34s user 1.32s system 47% cpu 16.039 total
def ten_recipes_after number
  first_elf_position = 0
  second_elf_position = 1
  scoreboard = Array.new(number+10) # Pre-create array to avoid the cost of growing it
  scoreboard[first_elf_position] = 3
  scoreboard[second_elf_position] = 7
  scoreboard_size = 2
  while scoreboard_size < number + 10
    next_recipe_scores = (scoreboard[first_elf_position] + scoreboard[second_elf_position]).to_s.split('').map(&:to_i)
    next_recipe_scores.each do |new_score|
      scoreboard[scoreboard_size] = new_score
      scoreboard_size += 1
    end
    first_elf_delta = scoreboard[first_elf_position] + 1
    second_elf_delta = scoreboard[second_elf_position] + 1
    first_elf_position = normalize_elf_position(first_elf_position + first_elf_delta, scoreboard_size)
    second_elf_position = normalize_elf_position(second_elf_position + second_elf_delta, scoreboard_size)
    # print_scoreboard first_elf_position, second_elf_position, scoreboard
    # puts scoreboard_size
  end
  scoreboard[number..(number+10-1)].join('')
end

def first_appearance_of number_pattern
  number_size = number_pattern.length
  array_grow_by = 1_000_000
  first_elf_position = 0
  second_elf_position = 1
  scoreboard = Array.new(array_grow_by) # Pre-create array to avoid the cost of growing it
  scoreboard[first_elf_position] = 3
  scoreboard[second_elf_position] = 7
  scoreboard_size = 2
  last_number ='37'
  loop do
    next_recipe_scores = (scoreboard[first_elf_position] + scoreboard[second_elf_position]).to_s.split('')
    next_recipe_scores.each do |new_score|
      scoreboard[scoreboard_size] = new_score.to_i
      scoreboard_size += 1
      scoreboard += Array.new(array_grow_by) if scoreboard_size == scoreboard.size
      last_number = last_number + new_score
      last_number = last_number[1..-1] if last_number.length > number_size
      return scoreboard_size-number_size if last_number == number_pattern
    end
    first_elf_delta = scoreboard[first_elf_position] + 1
    second_elf_delta = scoreboard[second_elf_position] + 1
    first_elf_position = normalize_elf_position(first_elf_position + first_elf_delta, scoreboard_size)
    second_elf_position = normalize_elf_position(second_elf_position + second_elf_delta, scoreboard_size)
    # print_scoreboard first_elf_position, second_elf_position, scoreboard
    # puts scoreboard_size
  end
end

if __FILE__ == $0
  puts ten_recipes_after(704321)
  puts first_appearance_of('704321')
end