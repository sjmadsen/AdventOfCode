from point import Point
import math

sample = """
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
""".strip().splitlines()

with open("day16.input") as file:
    input = [line.strip() for line in file]

# input = sample

width = len(input[0])
height = len(input)

maze = set()
for y, line in enumerate(input):
    for x, char in enumerate(line):
        if char == "#": continue
        if char == "S": start = Point(x, y)
        if char == "E": goal = Point(x, y)
        maze.add(Point(x, y))

def neighbors(p):
    points = []
    if p + Point(0, -1) in maze: points.append(p + Point(0, -1))
    if p + Point(0, 1) in maze: points.append(p + Point(0, 1))
    if p + Point(-1, 0) in maze: points.append(p + Point(-1, 0))
    if p + Point(1, 0) in maze: points.append(p + Point(1, 0))
    return points

def show_maze(visited):
    for y in range(height):
        s = ""
        for x in range(width):
            if Point(x, y) == start: s += "S"
            elif Point(x, y) == goal: s += "E"
            elif visited and Point(x, y) in visited: s += "O"
            elif Point(x, y) in maze: s += "."
            else: s += "#"
        print(s)

# remove dead-ends to speed up pathfinding later
check = list(maze)
while len(check) > 0:
    p = check.pop(0)
    if p == start or p == goal: continue
    n = neighbors(p)
    if len(n) == 1:
        maze.discard(p)
        check.extend(n)

facing = Point(1, 0)

def reconstruct_path(came_from, current):
    path = [current]
    while current in came_from:
        current = came_from[current]
        path.insert(0, current)
    return path

def distance(p1, p2):
    return math.sqrt(pow(abs(p2.x - p1.x), 2) + pow(abs(p2.y - p1.y), 2))

def move_cost(current, next, facing):
    return 1 if current + facing == next else 1001

def dijkstra(start, goal):
    dist = {}
    previous = {}
    queue = list(maze)
    dist[start] = 0

    while len(queue) > 0:
        current = min(queue, key=lambda x: dist.get(x, math.inf))
        queue.remove(current)
        for neighbor in neighbors(current):
            if neighbor in queue:
                if previous.get(current): facing = current - previous[current]
                else: facing = Point(1, 0)
                cost = dist[current] + move_cost(current, neighbor, facing)
                if cost < dist.get(neighbor, math.inf):
                    dist[neighbor] = cost
                    previous[neighbor] = current

    return previous

def path_cost(path, facing):
    if len(path) == 1: return 0
    direction = path[1] - path[0]
    return path_cost(path[1:], direction) + (1 if direction == facing else 1001)

path = reconstruct_path(dijkstra(start, goal), goal)
cost = path_cost(path, Point(1, 0))
print(cost)

def find_paths(max_cost, current, cost, goal, facing, visited, cheapest):
    if cheapest.get(current, math.inf) + 1001 < cost: return set()
    cheapest[current] = cost
    visited = visited | set([current])
    if cost > max_cost: return set()
    if current == goal: return visited
    valid_paths = set()
    for neighbor in neighbors(current):
        if not neighbor in visited:
            valid_paths |= find_paths(max_cost, neighbor, cost + move_cost(current, neighbor, facing), goal, neighbor - current, visited, cheapest)
    return valid_paths

visited = find_paths(cost, start, 0, goal, Point(1, 0), set(), {})
print(len(visited))
