sample = """RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE""".splitlines()

with open("day12.input") as file:
    input = [line.rstrip() for line in file]

# input = sample

grid = [[char for char in line] for line in input]
width = len(grid[0])
height = len(grid)

def find_region(grid, x, y, crop, region):
    if (x, y) in region: return region
    if x < 0 or x >= width or y < 0 or y >= height: return region
    if grid[y][x] != crop: return region
    region.add((x, y))
    region.update(find_region(grid, x, y - 1, crop, region))
    region.update(find_region(grid, x, y + 1, crop, region))
    region.update(find_region(grid, x - 1, y, crop, region))
    region.update(find_region(grid, x + 1, y, crop, region))
    return region

regions = []
assigned = set()
for y, row in enumerate(grid):
    for x, crop in enumerate(row):
        if (x, y) in assigned: continue
        region = find_region(grid, x, y, grid[y][x], set())
        regions.append(region)
        assigned.update(region)

def area(region): return len(region)

def perimeter(region):
    length = 0
    for x, y in region:
        if (x, y - 1) not in region: length += 1
        if (x, y + 1) not in region: length += 1
        if (x - 1, y) not in region: length += 1
        if (x + 1, y) not in region: length += 1
    return length

sum = 0
for region in regions:
    sum += area(region) * perimeter(region)

print(sum)

def is_corner(region, x, y, dx, dy):
    if (x + dx, y + dy) not in region:
        if (x, y + dy) not in region and (x + dx, y) not in region: return True
        if (x, y + dy) in region and (x + dx, y) in region: return True
    else:
        if (x, y + dy) not in region and (x + dx, y) not in region: return True
    return False

def sides(region):
    sum = 0
    for x, y in region:
        if is_corner(region, x, y, -1, -1): sum += 1
        if is_corner(region, x, y, 1, -1): sum += 1
        if is_corner(region, x, y, -1, 1): sum += 1
        if is_corner(region, x, y, 1, 1): sum += 1
    return sum

sum = 0
for region in regions:
    for x, y in region: break
    sum += area(region) * sides(region)

print(sum)
