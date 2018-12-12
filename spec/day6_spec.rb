require 'rspec'
require_relative '../day6/largest_area'
require_relative '../day6/safest_area'

test_input = [
'1, 1',
'1, 6',
'8, 3',
'3, 4',
'5, 5',
'8, 9'
]

describe '#largest_area' do
  it 'matches the example' do
    expected_output = 17
    expect(largest_area(test_input)).to eq(expected_output)
  end
end

describe '#safest_area' do
  it 'matches the example' do
    expected_output = 16
    expect(safest_area(test_input, within: 32)).to eq(expected_output)
  end
end
