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

      row_accumulator = 0
      column_accumulator = 0
      max_area_dimension.times do |cell_size|
        total = cell_power
        top_left_corner_cell = matrix[i-cell_size][j-cell_size]

        if cell_size > 0
          row_accumulator += matrix[i][j-cell_size].power
          column_accumulator += matrix[i-cell_size][j].power
          total += top_left_corner_cell.totals[cell_size-1]
          total += row_accumulator + column_accumulator
        end

        top_left_corner_cell.totals[cell_size] = total

        if total > current_max
          max_coordinates = top_left_corner_cell.coordinates + [cell_size + 1]
          current_max = total
        end
      end
    end
  end

  max_coordinates
end

if __FILE__ == $0
  puts largest_total_power(7672).inspect
end
