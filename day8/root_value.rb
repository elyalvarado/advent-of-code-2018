require_relative './tree_checksum'

def node_value node
  children = node[:nodes]
  metadata = node[:metadata]
  if children.empty?
    metadata.sum
  else
    metadata.inject(0) do |sum, val|
      sum += val > children.size ? 0 : node_value(children[val-1])
    end
  end
end

def root_value license
  license_numbers = license.split(' ').map(&:to_i)
  tree = build_tree(license_numbers)
  node_value(tree)
end

if __FILE__ == $0
  license = File.open("#{__dir__}/input.txt",'r').readlines[0].strip
  puts root_value(license)
end