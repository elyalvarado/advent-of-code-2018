require_relative './traverse'

def task_duration task:, base_step_duration:
  task.ord - 64 + base_step_duration
end

def multi_thread_traverse node_rules, max_workers:, base_step_duration: 0
  tree = build_tree(node_rules)

  current_time = 0
  traversed = []
  workers = []

  pending_nodes = tree.find_all { |_,relationships| relationships[:parents].empty? }.map(&:first)

  while !pending_nodes.empty? do
    pending_nodes.uniq!
    # puts "Pending: #{pending_nodes.inspect}"

    # schedule pending work
    while workers.size < max_workers && current_node = next_node_for(tree: tree, pending: pending_nodes, traversed: traversed) do
      break if current_node.empty?
      current_node = current_node.is_a?(Array) ? current_node.first : current_node
      # puts "Scheduling node: #{current_node.inspect}: #{tree[current_node].inspect}"
      pending_nodes.delete(current_node)
      workers.push({ task: current_node, remaining_time: task_duration(task: current_node, base_step_duration: base_step_duration)})
    end
    # puts "Done scheduling, current workers state: #{workers}"

    # execute next task with the less time remaining and increase duration
    time_delta = workers.min_by { |w| w[:remaining_time] }[:remaining_time]
    # puts "Time delta: #{time_delta}"
    done_workers = workers.find_all { |w| w[:remaining_time] == time_delta }.sort { |w| w[:task] }
    # puts "Done workers after time delta: #{done_workers.inspect}"
    done_workers.each do |w|
      traversed.push(w[:task])
      # puts "Adding done worker '#{w[:task]}' children to pending: #{tree[w[:task]][:children]}"
      pending_nodes += tree[w[:task]][:children]
      workers.delete(w)
    end

    # Advance time
    current_time += time_delta
    workers.map do |w|
      w[:remaining_time] -= time_delta
      w
    end
    # puts "traversed: #{traversed.inspect}"
    # puts "Remaining workers: #{workers.inspect}"
    # puts "Time passed: #{current_time}"
  end

  # no more work to schedule, advance time for the max remaining time
  # and fill the traversed array
  # puts "Finally no more work, emptying workers pool"
  unless workers.empty?
    current_time += workers.max_by { |w| w[:remaining_time] }[:remaining_time]
    traversed += workers.sort_by { |w| w[:remaining_time] }.map { |w| w[:task] }
  end
  # puts "Time passed: #{current_time}"
  # puts "traversed: #{traversed.inspect}"

  current_time
end


if __FILE__ == $0
  rules = File.open("#{__dir__}/input.txt",'r').readlines
  puts multi_thread_traverse(rules, max_workers: 5, base_step_duration: 60)
end