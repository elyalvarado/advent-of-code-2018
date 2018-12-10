require 'rspec'
require './day1/frequency'
require './day1/frequency_twice'

describe '#drift' do
  it 'Passes the provided examples' do
    expect(drift(drift_values: [1, 1, 1])).to equal 3
    expect(drift(drift_values: [1, 1, -2])).to equal 0
    expect(drift(drift_values: [-1, -2, -3])).to equal -6
  end
end

describe '#first_duplicate_frequency' do
  it 'Passes the provided examples' do
    expect(first_duplicate_frequency(drift_values: [1, -1])).to equal 0
    expect(first_duplicate_frequency(drift_values: [+3, +3, +4, -2, -4])).to equal 10
    expect(first_duplicate_frequency(drift_values: [-6, +3, +8, +5, -6])).to equal 5
    expect(first_duplicate_frequency(drift_values: [+7, +7, -2, -7, -4])).to equal 14
  end
end