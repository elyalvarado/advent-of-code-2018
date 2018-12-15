require 'rspec'
require_relative '../day9/marble_high_score'

test_inputs = [
  '9 players; last marble is worth 25 points: high score is 32',
  '10 players; last marble is worth 1618 points: high score is 8317',
  '13 players; last marble is worth 7999 points: high score is 146373',
  '17 players; last marble is worth 1104 points: high score is 2764',
  '21 players; last marble is worth 6111 points: high score is 54718',
  '30 players; last marble is worth 5807 points: high score is 37305'
]

describe '#pure_array_high_score' do
  test_inputs.each do |game|
    it "matches the example: #{game}" do
      expected_output = game.split(' ').last.to_i
      expect(pure_array_high_score(game)).to eq(expected_output)
    end
  end
end

describe '#array_rotate_high_score' do
  test_inputs.each do |game|
    it "matches the example: #{game}" do
      expected_output = game.split(' ').last.to_i
      expect(array_rotate_high_score(game)).to eq(expected_output)
    end
  end
end

describe '#linked_list_high_score' do
  test_inputs.each do |game|
    it "matches the example: #{game}" do
      expected_output = game.split(' ').last.to_i
      expect(linked_list_high_score(game)).to eq(expected_output)
    end
  end
end
