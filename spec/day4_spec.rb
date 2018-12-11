require 'rspec'
require_relative '../day4/most_minutes_asleep'
require_relative '../day4/../day4/most_frequently_asleep'

test_input = [
'[1518-11-01 00:00] Guard #10 begins shift',
'[1518-11-01 00:05] falls asleep',
'[1518-11-01 00:25] wakes up',
'[1518-11-01 00:30] falls asleep',
'[1518-11-01 00:55] wakes up',
'[1518-11-01 23:58] Guard #99 begins shift',
'[1518-11-02 00:40] falls asleep',
'[1518-11-02 00:50] wakes up',
'[1518-11-03 00:05] Guard #10 begins shift',
'[1518-11-03 00:24] falls asleep',
'[1518-11-03 00:29] wakes up',
'[1518-11-04 00:02] Guard #99 begins shift',
'[1518-11-04 00:36] falls asleep',
'[1518-11-04 00:46] wakes up',
'[1518-11-05 00:03] Guard #99 begins shift',
'[1518-11-05 00:45] falls asleep',
'[1518-11-05 00:55] wakes up'
]

describe '#most_minutes_asleep' do
  it 'matches the example' do
    expected_output = 240
    expect(most_minutes_asleep(test_input)).to eq(expected_output)
  end
end

describe '#most_frequently_asleep' do
  it 'matches the example' do
    expected_output = 4455
    expect(most_frequently_asleep(test_input)).to eq(expected_output)
  end
end
