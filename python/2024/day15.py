from point import Point

sample = """
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
""".strip().splitlines()

# sample = """
# #######
# #...#.#
# #.....#
# #..OO@#
# #..O..#
# #.....#
# #######

# <vv<<^^<<^^
# """.strip().splitlines()

with open("day15.input") as file:
    input = [line.strip() for line in file]

# input = sample

blank = input.index("")
grid = input[:blank]
moves = "".join(input[blank + 1:])

width = len(grid[0])
height = len(grid)

walls = set()
boxes = set()
for y, line in enumerate(grid):
    for x, char in enumerate(line):
        if char == "#": walls.add(Point(x, y))
        if char == "O": boxes.add(Point(x, y))
        if char == "@": robot = Point(x, y)

def move_boxes(position, vector):
    if position in walls: return False
    if position in boxes:
        if not move_boxes(position + vector, vector): return False
        boxes.remove(position)
        boxes.add(position + vector)
    return True

def show_grid():
    for y in range(height):
        s = ""
        for x in range(width):
            if Point(x, y) in walls: s += "#"
            elif Point(x, y) in boxes: s += "O"
            elif robot == Point(x, y): s += "@"
            else: s += "."
        print(s)

for move in moves:
    match move:
        case "^": vector = Point(0, -1)
        case "v": vector = Point(0, 1)
        case "<": vector = Point(-1, 0)
        case ">": vector = Point(1, 0)
    if move_boxes(robot + vector, vector): robot += vector

sum = 0
for box in boxes:
    sum += box.x + box.y * 100

print(sum)

walls = set()
boxes = set()
for y, line in enumerate(grid):
    for x, char in enumerate(line):
        if char == "#":
            walls.add(Point(x * 2, y))
            walls.add(Point(x * 2 + 1, y))
        if char == "O": boxes.add(Point(x * 2, y))
        if char == "@": robot = Point(x * 2, y)

def box_at(p):
    if p in boxes: return p
    if p + Point(-1, 0) in boxes: return p + Point(-1, 0)
    return None

def can_move_wide_box(position, vector):
    if position + vector in walls or position + vector + Point(1, 0) in walls: return False
    pushes = set()
    maybe_box = box_at(position + vector)
    if maybe_box: pushes.add(maybe_box)
    maybe_box = box_at(position + vector + Point(1, 0))
    if maybe_box: pushes.add(maybe_box)
    if len(pushes) == 0: return True
    return all([can_move_wide_box(x, vector) for x in pushes])

def move_wide_boxes(position, vector):
    if position in walls: return False
    box = box_at(position)
    if not box: return True
    if vector.y == 0:
        if vector.x == -1 and move_wide_boxes(box + vector, vector) or vector.x == 1 and move_wide_boxes(box + vector * 2, vector):
            boxes.remove(box)
            boxes.add(box + vector)
            return True
    else:
        if not can_move_wide_box(box, vector): return False
        pushes = set()
        maybe_box = box_at(box + vector)
        if maybe_box: pushes.add(maybe_box)
        maybe_box = box_at(box + vector + Point(1, 0))
        if maybe_box: pushes.add(maybe_box)
        if all([can_move_wide_box(x, vector) for x in pushes]):
            for b in pushes: move_wide_boxes(b, vector)
            boxes.remove(box)
            boxes.add(box + vector)
            return True
    return False

def show_wide_grid():
    for y in range(height):
        s = ""
        for x in range(width * 2):
            if Point(x, y) in boxes: s += "["
            elif Point(x - 1, y) in boxes: s += "]"
            elif robot == Point(x, y): s += "@"
            elif Point(x, y) in walls: s += "#"
            else: s += "."
        print(s)

for move in moves:
    match move:
        case "^": vector = Point(0, -1)
        case "v": vector = Point(0, 1)
        case "<": vector = Point(-1, 0)
        case ">": vector = Point(1, 0)
    if move_wide_boxes(robot + vector, vector): robot += vector

sum = 0
for box in boxes:
    sum += box.x + box.y * 100

print(sum)
