sample = """190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20""".splitlines()

with open("day7.input") as file:
    input = [line.rstrip() for line in file]

# input = sample

def solve1(operands, solution, partial):
    if len(operands) == 0: return partial == solution
    return solve1(operands[1:], solution, partial + operands[0]) or solve1(operands[1:], solution, partial * operands[0])

sum = 0
for line in input:
    solution, rest = line.split(": ")
    solution = int(solution)
    operands = [int(x) for x in rest.split()]
    if solve1(operands[1:], solution, operands[0]): sum += solution

print(sum)

def solve2(operands, solution, partial):
    if len(operands) == 0: return partial == solution
    return solve2(operands[1:], solution, partial + operands[0]) or solve2(operands[1:], solution, partial * operands[0]) or solve2(operands[1:], solution, int(str(partial) + str(operands[0])))

sum = 0
for line in input:
    solution, rest = line.split(": ")
    solution = int(solution)
    operands = [int(x) for x in rest.split()]
    if solve2(operands[1:], solution, operands[0]): sum += solution

print(sum)
