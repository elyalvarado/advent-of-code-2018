# def first_duplicate_frequency initial_frequency: 0, drift_values:
#   frequency = initial_frequency
#   frequencies_history = [ frequency ]
#   while true do
#     drift_values.each do |d|
#       frequency += d.to_i
#       if frequencies_history.include? frequency
#         return frequency
#       end
#       frequencies_history.push frequency
#     end
#   end
# end
require 'set'

def first_duplicate_frequency initial_frequency: 0, drift_values:
  frequency = initial_frequency
  frequencies_history = Set.new.add(initial_frequency)
  drift_values.cycle do |d|
    frequency += d.to_i
    return frequency unless frequencies_history.add?(frequency)
  end
end

if __FILE__ == $0
  values = File.open("#{__dir__}/input.txt",'r').readlines
  puts first_duplicate_frequency(initial_frequency: 0, drift_values: values)
end
