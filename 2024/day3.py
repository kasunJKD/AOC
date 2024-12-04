import re

# def calculate_mul_sum(file_path):
#     with open(file_path, 'r') as file:
#         corrupted_memory = file.read()
    
#     pattern = r"mul\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)"
    
#     matches = re.findall(pattern, corrupted_memory)
    
#     total_sum = sum(int(x) * int(y) for x, y in matches)
    
#     return total_sum

# file_path = "input.txt" 

# result = calculate_mul_sum(file_path)
# print("Sum of results:", result)

import re

def calculate_conditional_mul_sum(file_path):
    with open(file_path, 'r') as file:
        corrupted_memory = file.read()

    mul_pattern = r"mul\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)"
    control_pattern = r"\b(do|don't)\(\)"

    tokens = re.finditer(f"{control_pattern}|{mul_pattern}", corrupted_memory)

    mul_enabled = True
    total_sum = 0

    for token in tokens:
        if token.group(1): 
            instruction = token.group(1)
            mul_enabled = instruction == "do"
        elif token.group(2) and token.group(3):
            if mul_enabled:
                x, y = int(token.group(2)), int(token.group(3))
                total_sum += x * y

    return total_sum

file_path = "input.txt"

result = calculate_conditional_mul_sum(file_path)
print("Sum of enabled results:", result)