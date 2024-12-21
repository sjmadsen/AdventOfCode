from point import Point
import math
import heapq
import itertools as it
from collections import Counter

sample = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
""".strip().splitlines()

with open("day20.input") as file:
    input = [line.strip() for line in file]

# input = sample

width = len(input[0])
height = len(input)

maze = set()
walls = set()
for y, line in enumerate(input):
    for x, char in enumerate(line):
        if x == 0 or x == width - 1 or y == 0 or y == height - 1: continue
        if char == "#":
            walls.add(Point(x, y))
            continue
        if char == "S": start = Point(x, y)
        if char == "E": goal = Point(x, y)
        maze.add(Point(x, y))

def neighbors(maze, p):
    points = []
    if p + Point(0, -1) in maze: points.append(p + Point(0, -1))
    if p + Point(0, 1) in maze: points.append(p + Point(0, 1))
    if p + Point(-1, 0) in maze: points.append(p + Point(-1, 0))
    if p + Point(1, 0) in maze: points.append(p + Point(1, 0))
    return points

def reconstruct_path(came_from, current):
    path = [current]
    while current in came_from:
        current = came_from[current]
        path.insert(0, current)
    return path

def distance(p1, p2):
    return abs(p2.x - p1.x) + abs(p2.y - p1.y)

def heap_contains(heap, item):
    for _, i in heap:
        if i == item: return True
    return False

def a_star(maze, start, goal):
    open_set = []
    heapq.heappush(open_set, (distance(start, goal), start))
    came_from = {}
    g_score = {start: 0}
    while open_set:
        _, current = heapq.heappop(open_set)
        if current == goal: return came_from
        for neighbor in neighbors(maze, current):
            tentative_g = g_score.get(current, math.inf) + 1
            if tentative_g < g_score.get(neighbor, math.inf):
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g
                f_score = tentative_g + distance(neighbor, goal)
                if not heap_contains(open_set, neighbor):
                    heapq.heappush(open_set, (f_score, neighbor))
    return []

path = reconstruct_path(a_star(maze, start, goal), goal)

def cheat(path, max):
    path_index = {}
    for i, p in enumerate(path): path_index[p] = i
    savings = Counter()
    for pair in it.combinations(path, 2):
        d = distance(pair[0], pair[1])
        if d < 2 or d > max + 1: continue
        saved = abs(path_index[pair[0]] - path_index[pair[1]]) - d
        if saved > 0:
            savings[saved] += 1
    return savings

sum = 0
for saved, count in cheat(path, 1).items():
    if saved >= 100: sum += count

print(sum)

sum = 0
for saved, count in cheat(path, 19).items():
    if saved >= 100: sum += count

print(sum)
