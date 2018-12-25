require 'rspec'
require_relative '../day13/first_collision'

describe '#first_collision' do
  it 'matches example' do
    tracks = File.open("#{__dir__}/day13_sample_1.txt",'r').read
    expect(first_collision(tracks)).to eq([7,3])
  end
end

describe '#last_cart' do
  it 'matches example' do
    tracks = File.open("#{__dir__}/day13_sample_2.txt",'r').read
    expect(last_cart(tracks)).to eq([6,4])
  end
end
