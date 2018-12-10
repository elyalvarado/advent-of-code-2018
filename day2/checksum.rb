def checksum values
  ids_with_two_of_any_letter = 0
  ids_with_three_of_any_letter = 0
  values.each do |word|
    letters = word.split('')
    letter_counts = letters.inject(Hash.new(0)) do |m,l|
      m[l] += 1
      m
    end
    ids_with_two_of_any_letter += 1 if letter_counts.values.include?(2)
    ids_with_three_of_any_letter += 1 if letter_counts.values.include?(3)
  end
  ids_with_two_of_any_letter * ids_with_three_of_any_letter
end

if __FILE__ == $0
  values = File.open("#{__dir__}/input.txt",'r').readlines
  puts checksum(values)
end