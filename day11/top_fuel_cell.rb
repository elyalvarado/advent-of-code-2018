require 'ostruct'

GRID_SIZE = 300
FUEL_CELL_SIZE = 3

def fuel_cell_power_level x, y, serial_number:
  rack_id = x + 10
  power = rack_id * y
  power += serial_number
  power = power*rack_id
  power = '000' + power.to_s
  power = power.reverse[2].to_i - 5
  power
end

def within_matrix x, y
  x >= 0 && x < GRID_SIZE && y >= 0 && y < GRID_SIZE
end

def top_coordinates serial_number
  matrix = Array.new(300)
  current_max = 0
  max_coordinates = nil
  GRID_SIZE.times do |i|
    y = i + 1
    GRID_SIZE.times do |j|
      x = j + 1
      cell_power = fuel_cell_power_level(x, y, serial_number: serial_number)
      matrix[i] ||= Array.new(300)
      matrix[i][j] = OpenStruct.new(coordinates: [x,y], power: cell_power, total_power: 0)

      # After the previous step, the top left corner cell will have all his surrounding cells calculated, so we
      # can calculate the total and check for the max
      if within_matrix(j-FUEL_CELL_SIZE, i-FUEL_CELL_SIZE)
        top_left_corner_cell = matrix[i-FUEL_CELL_SIZE][j-FUEL_CELL_SIZE]
        total = 0
        FUEL_CELL_SIZE.times do |k|
          FUEL_CELL_SIZE.times do |l|
            level = matrix[i-FUEL_CELL_SIZE+k][j-FUEL_CELL_SIZE+l].power
            total += level
          end
        end
        top_left_corner_cell.total_power = total
        max_coordinates = top_left_corner_cell.coordinates if top_left_corner_cell.total_power > current_max
        current_max = top_left_corner_cell.total_power if top_left_corner_cell.total_power > current_max
      end
    end
  end

  max_coordinates
end

if __FILE__ == $0
  puts top_coordinates(7672).inspect
end

# Helpers functions for debugging purposes
private
def print_matrix_cell matrix, x, y
  puts "Printing cell: #{matrix[y-1][x-1].inspect}"
  cell = []
  total = 0
  FUEL_CELL_SIZE.times do |i|
    cell[i] ||= []
    FUEL_CELL_SIZE.times do |j|
      level = matrix[y-1+i][x-1+j].power
      total += level
      cell[i] << level
    end
  end
  puts cell.inspect
  puts total
end
def print_cell x, y, serial
  cell = []
  total = 0
  FUEL_CELL_SIZE.times do |i|
    cell[i] ||= []
    FUEL_CELL_SIZE.times do |j|
      level = fuel_cell_power_level x + j, y + i, serial_number: serial
      total += level
      cell[i] << level
    end
  end
  puts cell.inspect
  puts total
end


