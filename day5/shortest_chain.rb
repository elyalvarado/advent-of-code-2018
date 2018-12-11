require_relative './polymer_reaction'

def shortest_chain polymer
  polymer_array = polymer.split('')
  uniq_units = polymer_array.sort.map(&:upcase).uniq
  min = polymer_array.size
  uniq_units.each do |unit|
    size = polymer_reaction(polymer, skip: unit)
    min = size if size <= min
  end
  min
end

if __FILE__ == $0
  polymer = File.open("#{__dir__}/input.txt",'r').readlines[0].strip
  puts shortest_chain(polymer)
end