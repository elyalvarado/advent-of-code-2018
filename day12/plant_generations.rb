def parse_plants_and_rules pots_and_rules
  pots_and_rules = pots_and_rules.split("\n")
  initial_state = pots_and_rules.shift
  initial_state = initial_state.split(':')[1].strip
  prev_pot = nil
  initial_state.split('').each_with_index do |state, number|
    pot = Pot.new state: state
    prev_pot.append pot unless prev_pot.nil?
    prev_pot = pot
    @first = pot if number == 0
    @last = pot if number == initial_state.length - 1
  end

  _ = pots_and_rules.shift # empty line

  @rules = []
  pots_and_rules.each do |raw_rule|
    rule, result = raw_rule.split('=>').map(&:strip)
    @rules << rule if result == '#'
  end
end

class Pot
  attr_accessor :state, :left, :right, :number

  def initialize state:, number: 0
    @number =  number
    @state = state
  end

  def full_state
    "#{leftmost&.state || '.'}#{left&.state || '.'}#{state}#{right&.state || '.'}#{rightmost&.state || '.'}"
  end

  def leftmost
    self.left&.left
  end

  def rightmost
    self.right&.right
  end

  def has_plant?
    self.state == '#'
  end

  def append pot
    self.right = pot
    pot.left = self
    pot.number = self.number + 1
  end

  def prepend pot
    self.left = pot
    pot.right = self
    pot.number = self.number - 1
  end
end

def evolve_next_generation
  # First add plants to the beginning and end if needed
  plants_to_add_at_the_beginning = @first.state == '#' ? 2 : @first.right.state == '#' ? 1 : 0
  plants_to_add_at_the_end = @last.state == '#' ? 2 : @last.left.state == '#' ? 1 : 0

  plants_to_add_at_the_beginning.times do
    new_pot = Pot.new state: '.'
    @first.prepend new_pot
    @first = new_pot
  end

  plants_to_add_at_the_end.times do
    new_pot = Pot.new state: '.'
    @last.append new_pot
    @last = new_pot
  end

  current_full_states = {}
  current = @first
  while current do
    current_full_states[current.number] = current.full_state
    current = current.right
  end

  current = @first
  while current do
    matched = false
    prev_full_state = current_full_states[current.number]
    @rules.each do |rule|
      if rule == prev_full_state
        matched = true
        current.state = '#'
        break
        current.state = '#' && break if rule == prev_full_state
      end
    end
    current.state = '.' unless matched
    current = current.right
  end
end

def extrapolate_checksum current:, from:, to:, rate:
  current+(to-from-1)*rate
end

def plants_with_pots pots_and_rules, generations = 20
  parse_plants_and_rules(pots_and_rules)
  growth_rates = [ ]
  prev_checksum = checksum
  current_checksum = nil
  generations.times do |i|
    evolve_next_generation
    current_checksum = checksum

    # Keep track of the growth rate
    growth_rates << current_checksum - prev_checksum
    if growth_rates.size > 3  && growth_rates.last(3).uniq.size == 1 # Consider stable growth if after 3 generations rate is stable
      current_checksum = extrapolate_checksum(current: current_checksum, from: i, to: generations, rate: growth_rates.last)
      break
    end

    prev_checksum = checksum
  end
  current_checksum
end

def checksum
  current_checksum = 0
  current = @first
  while current do
    current_checksum += current.number if current.has_plant?
    current = current.right
  end
  current_checksum
end

def current_state
  current_state = ''
  current = @first
  while current do
    current_state += current.state
    current = current.right
  end
  current_state
end

if __FILE__ == $0
  pots_and_rules = File.open("#{__dir__}/input.txt",'r').read
  puts plants_with_pots(pots_and_rules, 50000000000)
end