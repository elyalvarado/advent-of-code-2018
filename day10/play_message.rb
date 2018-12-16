Light = Struct.new(:position, :velocity)

def parse_light light
  _, raw_pos, raw_vel = light.match(/position=<(.*)> velocity=<(.*)>/).to_a
  pos = raw_pos.split(",").map(&:to_i)
  vel = raw_vel.split(",").map(&:to_i)
  Light.new(pos, vel)
end

def lights_area lights
  min_x = lights.min_by { |light| light.position.first }.position[0]
  min_y = lights.min_by { |light| light.position.last }.position[1]
  max_x = lights.max_by { |light| light.position.first }.position[0]
  max_y = lights.max_by { |light| light.position.last }.position[1]
  { top_left_corner: [min_x, min_y], bottom_right_corner: [max_x, max_y], height: (max_y-min_y + 1), width: (max_x - min_x + 1) }
end

def move_lights lights
  lights.map { |l| l.clone }.each do |light|
    light.position = [light.position[0] + light.velocity[0], light.position[1] + light.velocity[1]]
  end
end

def lights_to_message_string lights
  area = lights_area(lights)
  lights_matrix = Array.new(area[:height])
  lights_matrix = lights_matrix.map { Array.new(area[:width], '.') }
  x_correction = area[:top_left_corner][0]
  y_correction = area[:top_left_corner][1]
  lights.each do |light|
    corrected_x = light.position[0] - x_correction
    corrected_y = light.position[1] - y_correction
    lights_matrix[corrected_y][corrected_x] = "#"
  end
  lights_matrix.map { |line| line.join('') }.join("\n")
end

def find_message raw_lights
  lights = raw_lights.map(&method(:parse_light))
  second = 0
  min_height = 1 << 64 # Max 64 bits integer
  while  true do
    new_lights = move_lights(lights)
    area = lights_area(new_lights)
    break if area[:height] > min_height
    second += 1
    min_height = area[:height] < min_height ? area[:height] : min_height
    lights = new_lights
  end
  puts second
  lights_to_message_string(lights)
end

if __FILE__ == $0
  lights = File.open("#{__dir__}/input.txt",'r').readlines
  puts find_message(lights)
end