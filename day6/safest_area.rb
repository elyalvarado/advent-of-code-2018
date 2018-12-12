require_relative './largest_area'

def safest_area coordinates, within:
  matrix = coordinates_matrix(coordinates)
  max_x = matrix.first.size
  max_y = matrix.size

  safe_area_counter = 0
  max_x.times do |x|
    max_y.times do |y|
      total_distance = matrix[y][x][:total_distance]
      safe_area_counter += 1 if  total_distance < within
    end
  end
  safe_area_counter
end


if __FILE__ == $0
  coordinates = File.open("#{__dir__}/input.txt",'r').readlines
  puts safest_area(coordinates, within: 10000)
end