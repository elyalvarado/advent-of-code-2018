def coordinates_matrix coordinates
  points = coordinates.map { |coordinate| coordinate.strip.split(',').map(&:to_i) }
  max_x = points.map(&:first).max + 1
  max_y = points.map(&:last).max + 1

  # Build matrix with distances
  matrix = []
  max_x.times do |x|
    max_y.times do |y|
      points.each_with_index do |point, index|
        matrix[y] ||= []
        matrix[y][x] ||= { current_min: max_x + max_y, current_min_index: nil, distances: {}, total_distance: 0 }
        point_x = point[0]
        point_y = point[1]
        manhattan_distance = (point_x - x).abs + (point_y - y).abs
        matrix[y][x][:distances][index] = manhattan_distance
        matrix[y][x][:total_distance] += manhattan_distance
        if matrix[y][x][:current_min] >= manhattan_distance
          matrix[y][x][:current_min_index] = manhattan_distance == matrix[y][x][:current_min] ? nil : index
          matrix[y][x][:current_min] = manhattan_distance
        end
      end
    end
  end

  matrix
end

def largest_area coordinates
  matrix = coordinates_matrix(coordinates)
  max_x = matrix.first.size
  max_y = matrix.size

  points_count = {}
  max_x.times do |x|
    max_y.times do |y|
      min_index = matrix[y][x][:current_min_index]
      next if min_index.nil? # Don't count nils because these are more than one point
      points_count[min_index] ||= 0
      points_count[min_index] += 1
    end
  end

  # remove border elements
  infinite_area_elements = []
  infinite_area_elements += matrix.first.map { |first_row_element| first_row_element[:current_min_index] }
  infinite_area_elements += matrix.last.map { |last_row_element| last_row_element[:current_min_index] }
  (0..(max_y-1)).map do |row|
    infinite_area_elements << matrix[row].first[:current_min_index]
    infinite_area_elements << matrix[row].last[:current_min_index]
  end

  infinite_area_elements = infinite_area_elements.compact.sort.uniq

  infinite_area_elements.each do |e|
    points_count.delete(e)
  end

  points_count.max_by { |_,count| count }[1]
end

if __FILE__ == $0
  coordinates = File.open("#{__dir__}/input.txt",'r').readlines
  puts largest_area(coordinates)
end