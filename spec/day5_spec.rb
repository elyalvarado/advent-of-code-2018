require 'rspec'
require_relative '../day5/polymer_reaction'
require_relative '../day5/shortest_chain'

describe '#polymer_reaction' do
  it 'matches the example' do
    test_input = 'dabAcCaCBAcCcaDA'
    expected_output = 10
    expect(polymer_reaction(test_input)).to eq(expected_output)
  end

  it 'keeps same case letter' do
    test_input = 'aabAAB'
    expected_output = 6
    expect(polymer_reaction(test_input)).to eq(expected_output)
  end
end

describe '#shortest_chain' do
  it 'matches the example' do
    test_input = 'dabAcCaCBAcCcaDA'
    expected_output = 4
    expect(shortest_chain(test_input)).to eq(expected_output)
  end
end
