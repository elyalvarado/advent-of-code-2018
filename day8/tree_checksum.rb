def build_tree numbers
  entry = { metadata: [], nodes: [] }
  number_of_child_nodes = numbers.shift
  number_of_metadata_entries = numbers.shift
  number_of_child_nodes.times do
    entry[:nodes].push(build_tree(numbers))
  end
  number_of_metadata_entries.times do
    entry[:metadata].push(numbers.shift)
  end
  entry
end

def traverse_tree tree, &block
  block.call(tree)
  tree[:nodes].each do |node_tree|
    traverse_tree(node_tree, &block)
  end
end

def license_checksum license
  license_numbers = license.split(' ').map(&:to_i)
  tree = build_tree(license_numbers)
  checksum = 0
  traverse_tree(tree) do |node|
    checksum += node[:metadata].sum
  end
  checksum
end

if __FILE__ == $0
  license = File.open("#{__dir__}/input.txt",'r').readlines[0].strip
  puts license_checksum(license)
end