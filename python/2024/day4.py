sample = """MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX""".splitlines()

with open("day4.input") as file:
    input = [line.rstrip() for line in file]

grid = [[x for x in line] for line in input]

def found_word(word, x, y, direction):
    if word == "": return 1
    if x < 0 or x >= len(grid[0]): return 0
    if y < 0 or y >= len(grid): return 0
    if grid[y][x] == word[0]:
        return found_word(word[1:], x + direction[0], y + direction[1], direction)
    return 0

found = 0
for y in range(len(grid)):
    for x in range(len(grid[y])):
        found += found_word("XMAS", x, y, (-1, -1))
        found += found_word("XMAS", x, y, (-1, 0))
        found += found_word("XMAS", x, y, (-1, 1))
        found += found_word("XMAS", x, y, (0, -1))
        found += found_word("XMAS", x, y, (0, 1))
        found += found_word("XMAS", x, y, (1, -1))
        found += found_word("XMAS", x, y, (1, 0))
        found += found_word("XMAS", x, y, (1, 1))

print(found)

found = 0
for y in range(len(grid)):
    for x in range(len(grid[y])):
        if found_word("MAS", x, y, (1, 1)) + found_word("SAM", x, y, (1, 1)) == 1:
            found += found_word("MAS", x + 2, y, (-1, 1))
            found += found_word("SAM", x + 2, y, (-1, 1))

print(found)
