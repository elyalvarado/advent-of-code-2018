# Step C must be finished before step A can begin.'
def parse_rule node_rule
  parts = node_rule.split(' ')
  { parent: parts[1], child: parts[7] }
end

def build_tree node_rules
  tree = {}
  node_rules.each do |rule|
    node = parse_rule(rule)
    tree[node[:parent]] ||= { parents: [], children: [] }
    tree[node[:parent]][:children].push(node[:child])
    tree[node[:child]] ||= { parents: [], children: [] }
    tree[node[:child]][:parents].push(node[:parent])
  end
  tree
end

def next_node_for tree:, pending:, traversed:
  pending.sort.each do |node|
    all_parents_traversed = true
    tree[node][:parents].each do |parent_node|
      all_parents_traversed = all_parents_traversed && traversed.include?(parent_node)
      break unless all_parents_traversed
    end
    return node if all_parents_traversed
  end
end

def traverse node_rules
  traversed = []
  tree = build_tree(node_rules)
  pending_nodes = tree.find_all { |_,relationships| relationships[:parents].empty? }.map(&:first)
  while !pending_nodes.empty? && current_node = next_node_for(tree: tree, pending: pending_nodes, traversed: traversed) do
    pending_nodes.delete(current_node)
    traversed.push(current_node)
    pending_nodes += tree[current_node][:children]
  end
  traversed.join
end

if __FILE__ == $0
  rules = File.open("#{__dir__}/input.txt",'r').readlines
  puts traverse(rules)
end