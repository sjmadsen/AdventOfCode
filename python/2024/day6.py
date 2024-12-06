sample = """....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...""".splitlines()

with open("day6.input") as file:
    input = [line.rstrip() for line in file]

# input = sample

width = len(input[0])
height = len(input)

obstructions = set()
for y, line in enumerate(input):
    for x, char in enumerate(line):
        match char:
            case "#": obstructions.add((x, y))
            case "^":
                start = (x, y)
                facing = (0, -1)

def in_bounds(x, y):
    return x >=0 and x < width and y >= 0 and y < height

def walk(position, facing, obstructions):
    x, y = position
    x += facing[0]
    y += facing[1]
    if (x, y) in obstructions:
        match facing:
            case (0, -1): facing = (1, 0)
            case (1, 0): facing = (0, 1)
            case (0, 1): facing = (-1, 0)
            case (-1, 0): facing = (0, -1)
        return walk(position, facing, obstructions)
    if not in_bounds(x, y): return None, facing
    return (x, y), facing

position = start
visited = set()
while True:
    position, facing = walk(position, facing, obstructions)
    if position == None: break
    visited.add(position)

print(len(visited))

def has_cycle(position, facing, obstructions, visited):
    visited = visited.copy()
    while True:
        position, facing = walk(position, facing, obstructions)
        if position == None: return False
        if (position, facing) in visited: return True
        visited.add((position, facing))

position = start
facing = (0, -1)
cycles = 0
for x, y in visited:
    obstructions2 = obstructions.copy()
    obstructions2.add((x, y))
    if has_cycle(position, facing, obstructions2, set()): cycles += 1

print(cycles)
