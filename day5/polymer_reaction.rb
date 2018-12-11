def polymer_reaction polymer, skip: nil
  polymer_array = polymer.split('')
  current_index = 0
  while current_index < polymer_array.length do
    if skip && polymer_array[current_index].upcase == skip.upcase
      polymer_array.delete_at(current_index)
      current_index -= 1 unless current_index == 0
    elsif polymer_array[current_index].upcase == polymer_array[current_index+1]&.upcase && polymer_array[current_index] != polymer_array[current_index+1]
      polymer_array.delete_at(current_index+1)
      polymer_array.delete_at(current_index)
      current_index -= 1 unless current_index == 0
    else
      current_index += 1
    end
  end
  polymer_array.length
end

if __FILE__ == $0
  polymer = File.open("#{__dir__}/input.txt",'r').readlines[0].strip
  puts polymer_reaction(polymer)
end