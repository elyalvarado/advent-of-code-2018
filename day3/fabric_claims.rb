def parse_claim claim
  # Claim format: #1 @ 1,3: 4x4
  id, _, position, dimension = claim.split(' ')
  position_x, position_y = position.split(',').map(&:to_i)
  dimension_x, dimension_y = dimension.split('x').map(&:to_i)
  { id: id, position: { x: position_x, y: position_y}, dimension: { x: dimension_x, y: dimension_y }}
end

def fabric_matrix_for claims
  fabric_matrix = []
  claims.each do |claim|
    parsed_claim = parse_claim(claim)
    parsed_claim[:dimension][:y].times do |y|
      parsed_claim[:dimension][:x].times do |x|
        fabric_matrix[y + parsed_claim[:position][:y]] ||= Array.new
        fabric_matrix[y + parsed_claim[:position][:y]][x + parsed_claim[:position][:x]] ||= 0
        fabric_matrix[y + parsed_claim[:position][:y]][x + parsed_claim[:position][:x]] += 1
      end
    end
  end
  fabric_matrix
end

def overlapping_fabric claims
  fabric_matrix = fabric_matrix_for(claims)
  fabric_matrix.inject(0) { |sum,rows| sum += (rows && rows.find_all { |column| column && column > 1 }.size) || 0 }
end

if __FILE__ == $0
  claims = File.open("#{__dir__}/input.txt",'r').readlines
  puts overlapping_fabric(claims)
end