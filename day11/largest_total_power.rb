require_relative './top_fuel_cell'

def largest_total_power serial_number
  matrix = Array.new(300)
  current_max = 0
  max_coordinates = nil
  GRID_SIZE.times do |i|
    y = i + 1
    GRID_SIZE.times do |j|
      x = j + 1
      cell_power = fuel_cell_power_level(x, y, serial_number: serial_number)
      matrix[i] ||= Array.new(300)
      matrix[i][j] = OpenStruct.new(coordinates: [x,y], power: cell_power, totals: ({ }))

      max_area_dimension = [x,y].min

      max_area_dimension.times do |cell_size|
        total = cell_power
        top_left_corner_cell = matrix[i-cell_size][j-cell_size]
        total += top_left_corner_cell.totals[cell_size-1] if cell_size > 0
        cell_size.times do |k|
          total += matrix[i][j-k-1].power
          total += matrix[i-k-1][j].power
        end

        top_left_corner_cell.totals[cell_size] = total

        if total > current_max
          max_coordinates = top_left_corner_cell.coordinates + [cell_size + 1]
          current_max = total
          # puts "new max coordinates: #{max_coordinates.inspect} calculating cell #{matrix[i][j].inspect}"
        end
      end
    end
  end

  max_coordinates
end

if __FILE__ == $0
  puts largest_total_power(7672).inspect
end
