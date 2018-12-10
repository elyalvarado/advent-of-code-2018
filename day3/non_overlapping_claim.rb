require_relative './fabric_claims'

def non_overlapping_claim_id claims
  # First pass: fill matrix
  fabric_matrix = fabric_matrix_for(claims)

  # second pass: find if claim overlaps
  claims.each do |claim|
    parsed_claim = parse_claim(claim)
    overlaps = false
    parsed_claim[:dimension][:y].times do |y|
      parsed_claim[:dimension][:x].times do |x|
        overlaps ||= fabric_matrix[y + parsed_claim[:position][:y]][x + parsed_claim[:position][:x]] > 1
      end
      next if overlaps
    end
    return parsed_claim[:id] unless overlaps
  end
end

if __FILE__ == $0
  claims = File.open("#{__dir__}/input.txt",'r').readlines
  puts non_overlapping_claim_id(claims)
end