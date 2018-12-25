require 'rspec'
require_relative '../day14/ten_recipes_after'

examples = [
  [9, '5158916779'],
  [5, '0124515891'],
  [18, '9251071085'],
  [2018, '5941429882']
]

describe '#ten_recipes_after' do
  examples.each do |example|
    it "after #{example[0]} is #{example[1]}" do
      expect(ten_recipes_after(example[0])).to eq(example[1])
    end
  end
end

examples2 = [
    ['51589', 9],
    ['01245', 5],
    ['92510', 18],
    ['59414', 2018]
]

describe '#first_appearence_of' do
  examples2.each do |example|
    it "#{example[0]} appears after #{example[1]} recipes" do
      expect(first_appearance_of(example[0])).to eq(example[1])
    end
  end
end