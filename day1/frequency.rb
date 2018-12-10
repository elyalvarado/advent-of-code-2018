def drift initial_frequency: 0, drift_values:
  frequency = initial_frequency
  drift_values.each do |d|
    frequency += d.to_i
  end
  frequency
end

if __FILE__ == $0
  values = File.open("#{__dir__}/input.txt",'r').readlines
  puts drift(initial_frequency: 0, drift_values: values)
end