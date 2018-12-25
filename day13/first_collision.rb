class Track
  attr_reader :x, :y, :char
  attr_accessor :left, :right, :up, :down, :carts

  def initialize char, x, y
    @char, @x, @y = char, x, y
    @carts = []
  end

  def coordinates
    [@x, @y]
  end

  def intersection?
    @left && @right && @up && @down
  end

  def corner?
    !intersection? && (@left && @down) || (@up && @left) || (@right && @up) || (@down && @right)
  end
end

class Cart
  DIRECTIONS = %w{ left straight right }
  attr_accessor :current_track, :current_direction, :alive

  def initialize current_track, current_direction
    @intersection_count = 0
    @current_track = current_track
    @current_direction = current_direction
    @alive = true
  end

  def move
    @current_track.intersection? ? move_at_intersection : move_on_tracks
    @current_track.carts.size > 1 ? false : true
  end

  def x
    @current_track.x
  end

  def y
    @current_track.y
  end

  private
  def go_straight
    @current_track.carts.delete(self)
    @current_track = @current_track.send(@current_direction.to_sym)
    @current_track.carts.push(self)
  end

  def go direction
    @current_track.carts.delete(self)
    @current_direction = direction.to_s
    @current_track = @current_track.send(direction.to_sym)
    @current_track.carts.push(self)
  end

  def go_up
    go('up')
  end

  def go_down
    go('down')
  end

  def go_right
    go('right')
  end

  def go_left
    go('left')
  end

  def turn_left
    case self.current_direction
    when 'up'
      go_left
    when 'down'
      go_right
    when 'left'
      go_down
    when 'right'
      go_up
    end
  end

  def turn_right
    case self.current_direction
    when 'up'
      go_right
    when 'down'
      go_left
    when 'left'
      go_up
    when 'right'
      go_down
    end
  end

  def vertical?
    @current_direction == 'up' || @current_direction == 'down'
  end

  def horizontal?
    !vertical?
  end

  def move_at_intersection
    direction_to_go = DIRECTIONS[@intersection_count % 3]
    case direction_to_go
    when 'left'
      turn_left
    when 'right'
      turn_right
    when 'straight'
      go_straight
    end
    @intersection_count += 1
  end

  def move_on_tracks
    go_straight && return unless @current_track.corner?
    if vertical?
      @current_track.left ? go_left : go_right
    else
      @current_track.up ? go_up : go_down
    end
  end
end

def parse_tracks tracks
  map_cart_char_to_track = { 'v' => '|', '^' => '|', '>' => '-', '<' => '-' }
  map_cart_char_to_direction = { 'v' => 'down', '^' => 'up', '>' => 'right', '<' => 'left' }
  carts = []
  open_tracks = []
  tracks.split("\n").each_with_index do |track_line, y|
    prev_track = nil
    track_line.split('').each_with_index do |track_char, x|
      char = track_char.strip

      if char.empty?
        prev_track = nil
        next
      end

      has_cart = %w{ v ^ < > }.include?(char)
      underlying_char = has_cart ? map_cart_char_to_track[char] : char

      current_track = Track.new(underlying_char, x, y)

      if prev_track
        # If any of the prev or current char is vertical, then its like there is no prev track
        prev_track = nil if prev_track.char == '|'
        prev_track = nil if prev_track && underlying_char == '|'
        # If there are opposing corners, then there is also no prev track
        prev_track = nil if prev_track && underlying_char == '/' && (prev_track.char == '\\' || prev_track.char == '/')
        prev_track = nil if prev_track && underlying_char == '\\' && (prev_track.char == '/' || prev_track.char == '\\')
      end

      if has_cart
        # puts "Has cart: #{char}, underlying track char: #{underlying_char}"
        current_cart = Cart.new(current_track, map_cart_char_to_direction[char])
        current_track.carts << current_cart
        carts << current_cart
      end

      if prev_track
        current_track.left = prev_track
        prev_track.right = current_track
      end

      # puts "Track: [#{current_track.x},#{current_track.y}]. Underlying char: #{underlying_char}. Prev Track = #{prev_track}. Open tracks: #{open_tracks.map { |t| [t.x, t.y]}.inspect}"
      # The following chars remain open after processing this line, so add them to the open_tracks array
      if %w{ / \\ | + }.include?(underlying_char)
        # The only exception are the bottom-left or bottom-right corners which don't remain open
        open_tracks << current_track unless (underlying_char =='\\' && prev_track.nil?) || (underlying_char == '/' && prev_track)
        # except for the top-left and top-right corners look the track above and remove it from the open tracks
        unless (underlying_char =='/' && prev_track.nil?) || (underlying_char == '\\' && prev_track)
          track_above = open_tracks.delete(open_tracks.find { |t| t.x == current_track.x && t.y == current_track.y - 1 })
          current_track.up = track_above
          track_above.down = current_track
        end
      end

      prev_track = current_track
    end
  end
  carts
end

def first_collision input
  carts = parse_tracks(input)
  while true do
    carts.sort! do |c1,c2|
      if c1.y > c2.y || (c1.y == c2.y && c1.x > c2.x)
        1
      elsif c1.y < c2.y || (c1.y == c2.y && c1.x < c2.x)
        -1
      else
        0
      end
    end
    # puts carts.map { |c| "#{c.current_track.coordinates.inspect}, going: #{c.current_direction}"}.inspect
    carts.each do |cart|
      return cart.current_track.coordinates unless cart.move
    end
  end
end

def last_cart input
  carts = parse_tracks(input)
  # iteration = 0
  while true do
    carts.sort! do |c1,c2|
      if c1.y > c2.y || (c1.y == c2.y && c1.x > c2.x)
        1
      elsif c1.y < c2.y || (c1.y == c2.y && c1.x < c2.x)
        -1
      else
        0
      end
    end
    # puts "\n\nITERATION ##{iteration += 1} ***********************************"
    # puts carts.map { |c| "#{c.current_track.coordinates.inspect}, going: #{c.current_direction}\n"}
    carts_removed = []
    carts.clone.each do |cart|
      next if carts_removed.include?(cart)
      unless cart.move
        current_track = cart.current_track
        carts_to_remove = current_track.carts
        # puts "There was a collision in #{current_track.x},#{current_track.y}. Carts to remove: #{carts_to_remove.map { |cx| [cx.x, cx.y]}.inspect}. Carts size: #{carts.size}"
        current_track.carts = []
        carts_to_remove.each do |c|
          carts.delete(c)
          carts_removed << c
        end
        # puts "After removing: Carts size: #{carts.size}"
      end
    end

    # puts "After iteration: current carts: #{carts.map { |cx| [cx.x, cx.y]}.inspect}"

    if carts.size == 1
      return carts.first.current_track.coordinates
    end
  end
end

if __FILE__ == $0
  tracks = File.open("#{__dir__}/input.txt",'r').read
  puts first_collision(tracks).inspect
  puts last_cart(tracks).inspect
end