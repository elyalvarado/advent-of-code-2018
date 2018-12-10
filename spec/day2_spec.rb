require 'rspec'
require './day2/checksum'
require './day2/common_letters'

describe '#checksum' do
  it 'matches the example' do
    test_input = %w{ abcdef bababc abbcde abcccd aabcdd abcdee ababab }
    expected_output = 12
    expect(checksum(test_input)).to eq(expected_output)
  end
end

describe '#common_letters' do
  it 'matches the example' do
    test_input = %w{ abcde fghij klmno pqrst fguij axcye wvxyz }
    expected_output = 'fgij'
    expect(common_letters(test_input)).to eq(expected_output)
  end
end