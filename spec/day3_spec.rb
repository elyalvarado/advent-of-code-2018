require 'rspec'
require_relative '../day3/fabric_claims'
require_relative '../day3/non_overlapping_claim'

test_input = [
    '#1 @ 1,3: 4x4',
    '#2 @ 3,1: 4x4',
    '#3 @ 5,5: 2x2'
]

describe '#fabric_claims' do
  it 'matches the example' do
    expected_output = 4
    expect(overlapping_fabric(test_input)).to eq(expected_output)
  end
end

describe '#non_overlapping_claim_id' do
  it 'matches the example' do
    expected_output = '#3'
    expect(non_overlapping_claim_id(test_input)).to eq(expected_output)
  end
end
