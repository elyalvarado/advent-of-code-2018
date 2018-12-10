require 'rspec'
require './day3/fabric_claims'

describe '#fabric_claims' do
  it 'matches the example' do
    test_input = [
        '#1 @ 1,3: 4x4',
        '#2 @ 3,1: 4x4',
        '#3 @ 5,5: 2x2'
    ]
    expected_output = 4
    expect(overlapping_fabric(test_input)).to eq(expected_output)
  end
end