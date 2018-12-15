GameParams = Struct.new(:players, :marbles)

def parse_params params
  # 10 players; last marble is worth 1618 points
  a = params.split(' ')
  GameParams.new(a[0].to_i, a[6].to_i)
end

def normalize_index index, size
  next_index = index < 0 ? normalize_index(size + index, size) : index
  next_index % size
end

# Pure array implementation
def pure_array_high_score params
  game_params = parse_params(params)
  marbles = [0]
  scores = {}
  current_marble_index = 0
  game_params.marbles.times do |marble|
    current_marble = marble + 1
    if current_marble % 23 == 0
      next_marble_index = normalize_index(current_marble_index - 7, marbles.size)
      removed_marble = marbles.delete_at(next_marble_index)
      player = current_marble % game_params.players
      scores[player] ||= 0
      scores[player] += removed_marble + current_marble
      current_marble_index = next_marble_index
    else
      next_marble_index = current_marble_index + 2
      next_marble_index = normalize_index(next_marble_index, marbles.size) if next_marble_index > marbles.size
      marbles.insert(next_marble_index, current_marble)
      current_marble_index = next_marble_index
    end
    printable_marbles = marbles.clone
    printable_marbles[current_marble_index] = "(#{marbles[current_marble_index]})"
  end
  scores.max_by { |_,v| v }[1]
end

# Array rotate implementation
def array_rotate_high_score params
  game_params = parse_params(params)
  marbles = [0]
  scores = {}
  game_params.marbles.times do |marble|
    current_marble = marble + 1
    if current_marble % 23 == 0
      player = current_marble % game_params.players
      scores[player] ||= 0
      marbles.rotate!(-7)
      removed_marble = marbles.shift
      scores[player] += removed_marble + current_marble
    else
      marbles.rotate!(2)
      marbles.prepend(current_marble)
    end
  end
  scores.max_by { |_,v| v }[1]
end

# Linked List object
class Marble
  attr_reader :number
  attr_accessor :clockwise, :counter_clockwise
  def initialize val
    @number = val
  end

  def clockwise_times n
    current = self
    n.times do
      current = current.clockwise
    end
    current
  end

  def counter_clockwise_times n
    current = self
    n.times do
      current = current.counter_clockwise
    end
    current
  end

  def remove
    prev_marble = self.counter_clockwise
    next_marble = self.clockwise
    prev_marble.clockwise = next_marble
    next_marble.counter_clockwise = prev_marble
    self.clockwise = nil
    self.counter_clockwise = nil
  end

  def add_after marble
    next_marble = marble.clockwise
    self.counter_clockwise = marble
    marble.clockwise = self
    self.clockwise = next_marble
    next_marble.counter_clockwise = self
  end
end

def linked_list_high_score params, marbles_multiplier_factor = 1
  game_params = parse_params(params)
  scores = Hash.new(0)
  first_marble = Marble.new(0)
  first_marble.clockwise = first_marble
  first_marble.counter_clockwise = first_marble
  current_marble = first_marble
  (game_params.marbles*marbles_multiplier_factor).times do |marble|
    marble_number = marble + 1
    if marble_number % 23 == 0
      player = marble_number % game_params.players
      marble_to_remove = current_marble.counter_clockwise_times(7)
      current_marble = marble_to_remove.clockwise
      marble_to_remove.remove
      scores[player] += marble_to_remove.number + marble_number
    else
      next_marble = Marble.new(marble_number)
      next_marble.add_after(current_marble.clockwise)
      current_marble = next_marble
    end
  end
  scores.max_by { |_,v| v }[1]
end

if __FILE__ == $0
  params = File.open("#{__dir__}/input.txt",'r').readlines[0].strip
  puts linked_list_high_score(params)
  puts linked_list_high_score(params, 100)
end