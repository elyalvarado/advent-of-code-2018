require 'rspec'
require_relative '../day7/traverse'

test_input = [
  'Step C must be finished before step A can begin.',
  'Step C must be finished before step F can begin.',
  'Step A must be finished before step B can begin.',
  'Step A must be finished before step D can begin.',
  'Step B must be finished before step E can begin.',
  'Step D must be finished before step E can begin.',
  'Step F must be finished before step E can begin.'
]

describe '#traverse' do
  it 'matches the example' do
    expected_output = 'CABDFE'
    expect(traverse(test_input)).to eq(expected_output)
  end
end

