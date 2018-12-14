require 'rspec'
require_relative '../day8/tree_checksum'
require_relative '../day8/root_value'

test_input = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2'

describe '#license_checksum' do
  it 'matches the example' do
    expected_output = 138
    expect(license_checksum(test_input)).to eq(expected_output)
  end
end

describe '#root_value' do
  it 'matches the example' do
    expected_output = 66
    expect(root_value(test_input)).to eq(expected_output)
  end
end
