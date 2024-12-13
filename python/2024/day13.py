import re

sample = """Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279""".strip()

with open("day13.input") as file:
    input = file.read().strip()

# input = sample

machines = input.split("\n\n")

def intercept(x, y, slope):
    return y - slope * x

def intersection(s1, s2, i1, i2):
    if s1 == s2: return None
    x = (i2 - i1) / (s1 - s2)
    y = s1 * ((i2 - i1) / (s1 - s2)) + i1
    return (x, y)

def cost(prize_x, prize_y, mid, a, b):
    if not (round(mid[0] / a[0], 2).is_integer() and round((prize_x - mid[0]) / b[0], 2).is_integer()): return None
    return (mid[0] / a[0]) * 3 + (prize_x - mid[0]) / b[0]

def parse_part1(machine):
    lines = machine.splitlines()
    m = re.search(r"X\+(\d+), Y\+(\d+)", lines[0])
    button_a_x = int(m.group(1))
    button_a_y = int(m.group(2))
    m = re.search(r"X\+(\d+), Y\+(\d+)", lines[1])
    button_b_x = int(m.group(1))
    button_b_y = int(m.group(2))
    m = re.search(r"X=(\d+), Y=(\d+)", lines[2])
    return (button_a_x, button_a_y, button_b_x, button_b_y, int(m.group(1)), int(m.group(2)))

def is_winner(machine):
    button_a_x, button_a_y, button_b_x, button_b_y, prize_x, prize_y = machine

    a_slope = button_a_y / button_a_x
    b_slope = button_b_y / button_b_x
    button_a_intercept = intercept(prize_x, prize_y, a_slope)
    button_b_intercept = intercept(prize_x, prize_y, b_slope)
    p1 = intersection(a_slope, b_slope, 0, button_b_intercept)
    p2 = intersection(a_slope, b_slope, button_a_intercept, 0)
    tokens = []
    tokens.append(cost(prize_x, prize_y, p1, (button_a_x, button_a_y), (button_b_x, button_b_y)))
    tokens.append(cost(prize_x, prize_y, p2, (button_a_x, button_a_y), (button_b_x, button_b_y)))
    tokens = [int(round(x)) for x in filter(None, tokens)]
    if tokens == []: return None
    return int(round(min(tokens)))

sum = 0
for machine in machines:
    tokens = is_winner(parse_part1(machine))
    sum += tokens if tokens != None else 0

print(sum)

def parse_part2(machine):
        button_a_x, button_a_y, button_b_x, button_b_y, prize_x, prize_y = parse_part1(machine)
        return (button_a_x, button_a_y, button_b_x, button_b_y, prize_x + 10000000000000, prize_y + 10000000000000)

def is_winner2(machine):
    button_a_x, button_a_y, button_b_x, button_b_y, prize_x, prize_y = machine
    b = (button_a_y * prize_x - button_a_x * prize_y) / (button_a_y * button_b_x - button_a_x * button_b_y)
    a = (prize_x - button_b_x * b) / button_a_x
    if not (round(a, 6).is_integer() and round(b, 6).is_integer()): return None
    return int(a * 3 + b)

sum = 0
for machine in machines:
    tokens = is_winner2(parse_part2(machine))
    sum += tokens if tokens != None else 0

# The correct answer for the sample data is 875318608908
print(sum)
