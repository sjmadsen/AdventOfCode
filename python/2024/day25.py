sample = """
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
""".strip()

with open("day25.input") as file:
    input = file.read().strip()

# input = sample

def count(lines):
    block = []
    for x in range(len(lines[0])):
        sum = 0
        for y in range(len(lines)):
            if lines[y][x] == "#": sum += 1
        block.append(sum)
    return block

locks = []
keys = []
blocks = input.split("\n\n")
for block in blocks:
    lines = block.splitlines()
    if lines[0].startswith("#"):
        locks.append(count(lines[1:-1]))
    else:
        keys.append(count(lines[1:-1]))

def fit(lock, key):
    overlap = []
    for l, k in zip(lock, key):
        overlap.append(l + k)
    return all(map(lambda x: x < 6, overlap))

sum = 0
for lock in locks:
    for key in keys:
        if fit(lock, key): sum += 1

print(sum)
