require 'rspec'
require_relative '../day12/plant_generations'

example_input = <<RULES
initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
RULES

describe 'My behaviour' do
  it '#plant_with_pots' do
    expect(plants_with_pots(example_input)).to eq(325)
  end
end