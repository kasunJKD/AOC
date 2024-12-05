def read_input(file_path):
    with open(file_path, 'r') as file:
        lines = file.read().splitlines()
    
    # Split rules and updates
    blank_line_index = lines.index('')
    rules_input = lines[:blank_line_index]
    updates_input = lines[blank_line_index + 1:]
    
    return rules_input, updates_input

def parse_rules_and_updates(rules_input, updates_input):
    from collections import defaultdict
    rules = defaultdict(set)
    for rule in rules_input:
        x, y = rule.split('|')
        rules[x].add(y)
    updates = [update.split(',') for update in updates_input]
    return rules, updates

def is_valid_update(update, rules):
    from collections import defaultdict, deque
    graph = defaultdict(list)
    in_degree = defaultdict(int)
    update_set = set(update)

    # Build graph and in-degree only for relevant nodes in update
    for x in update:
        graph[x] = []
    for x in update_set:
        for y in rules[x]:
            if y in update_set:
                graph[x].append(y)
                in_degree[y] += 1

    # Perform topological sort
    queue = deque([node for node in update if in_degree[node] == 0])
    sorted_order = []

    while queue:
        current = queue.popleft()
        sorted_order.append(current)
        for neighbor in graph[current]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    return len(sorted_order) == len(update)

def calculate_middle_sum(file_path):
    rules_input, updates_input = read_input(file_path)
    rules, updates = parse_rules_and_updates(rules_input, updates_input)
    middle_sum = 0

    for update in updates:
        if is_valid_update(update, rules):
            middle_sum += int(update[len(update) // 2])

    return middle_sum

# File path to the input
file_path = 'test5.txt'
print("Sum of middle pages:", calculate_middle_sum(file_path))