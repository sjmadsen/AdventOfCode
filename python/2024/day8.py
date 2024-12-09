import itertools as it

sample = """............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............""".splitlines()

with open("day8.input") as file:
    input = [line.rstrip() for line in file]

# input = sample

width = len(input[0])
height = len(input)

antennas = {}
for y, line in enumerate(input):
    for x, char in enumerate(line):
        if char == ".": continue
        if char not in antennas: antennas[char] = []
        antennas[char].append((x, y))

def in_bounds(a):
    return a[0] >= 0 and a[0] < width and a[1] >= 0 and a[1] < height

def slope(a, b):
    return (b[0] - a[0], b[1] - a[1])

antinodes = set()
for antenna in antennas:
    locations = antennas[antenna]
    for a, b in it.combinations(locations, 2):
        s = slope(a, b)
        antinode = (a[0] - s[0], a[1] - s[1])
        if in_bounds(antinode): antinodes.add(antinode)
        antinode = (b[0] + s[0], b[1] + s[1])
        if in_bounds(antinode): antinodes.add(antinode)

print(len(antinodes))

antinodes = set()
for antenna in antennas:
    locations = antennas[antenna]
    for a, b in it.combinations(locations, 2):
        s = slope(a, b)
        antinode = a
        while in_bounds(antinode):
            antinodes.add(antinode)
            antinode = (antinode[0] - s[0], antinode[1] - s[1])

        antinode = a
        while in_bounds(antinode):
            antinodes.add(antinode)
            antinode = (antinode[0] + s[0], antinode[1] + s[1])

print(len(antinodes))
