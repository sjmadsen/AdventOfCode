sample = """89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732""".splitlines()

with open("day10.input") as file:
    input = [line.rstrip() for line in file]

# input = sample

grid = [[int(x) for x in line] for line in input]
width = len(grid[0])
height = len(grid)

def walk(x, y, value):
    if x < 0 or x >= width or y < 0 or y >= height: return set()
    if grid[y][x] != value: return set()
    if value == 9: return set([(x, y)])
    reachable = set()
    reachable.update(walk(x, y - 1, value + 1))
    reachable.update(walk(x - 1, y, value + 1))
    reachable.update(walk(x + 1, y, value + 1))
    reachable.update(walk(x, y + 1, value + 1))
    return reachable

sum = 0
for y in range(height):
    for x in range(width):
        sum += len(walk(x, y, 0))

print(sum)

def walk_distinct(x, y, value):
    if x < 0 or x >= width or y < 0 or y >= height: return 0
    if grid[y][x] != value: return 0
    if value == 9: return 1
    return walk_distinct(x, y - 1, value + 1) + walk_distinct(x - 1, y, value + 1) + walk_distinct(x + 1, y, value + 1) + walk_distinct(x, y + 1, value + 1)

sum = 0
for y in range(height):
    for x in range(width):
        sum += walk_distinct(x, y, 0)

print(sum)
