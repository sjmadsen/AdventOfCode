from point import Point
import math

sample = """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
""".strip().splitlines()

with open("day18.input") as file:
    input = [line.strip() for line in file]

width = 71
height = 71
iterations = 1024

# input = sample
# width = 7
# height = 7
# iterations = 12

bytes = []
for line in input:
    x, y = line.split(",")
    bytes.append(Point(int(x), int(y)))

def build_maze(iterations):
    walls = set()
    for i in range(iterations):
        walls.add(bytes[i])
    return walls

def show_maze(visited):
    for y in range(height):
        s = ""
        for x in range(width):
            if visited and Point(x, y) in visited: s += "O"
            elif Point(x, y) in walls: s += "#"
            else: s += "."
        print(s)

walls = build_maze(iterations)
start = Point(0, 0)
goal = Point(width - 1, height - 1)

def neighbors(p):
    points = []
    if p + Point(0, -1) not in walls: points.append(p + Point(0, -1))
    if p + Point(0, 1) not in walls: points.append(p + Point(0, 1))
    if p + Point(-1, 0) not in walls: points.append(p + Point(-1, 0))
    if p + Point(1, 0) not in walls: points.append(p + Point(1, 0))
    return points

def reconstruct_path(came_from, current):
    path = [current]
    while current in came_from:
        current = came_from[current]
        path.insert(0, current)
    return path

def distance(p1, p2):
    return math.sqrt(pow(abs(p2.x - p1.x), 2) + pow(abs(p2.y - p1.y), 2))

def dijkstra(start, goal):
    dist = {}
    previous = {}
    queue = []
    for y in range(height):
        for x in range(width):
            if Point(x, y) not in walls: queue.append(Point(x, y))
    dist[start] = 0

    while len(queue) > 0:
        current = min(queue, key=lambda x: dist.get(x, math.inf))
        queue.remove(current)
        for neighbor in neighbors(current):
            if neighbor in queue:
                if not current in dist: return {}
                cost = dist[current] + 1
                if cost < dist.get(neighbor, math.inf):
                    dist[neighbor] = cost
                    previous[neighbor] = current

    return previous

path = reconstruct_path(dijkstra(start, goal), goal)
print(len(path) - 1)

for i in range(iterations, len(bytes)):
    byte = bytes[i]
    walls.add(byte)
    if byte in path:
        path = reconstruct_path(dijkstra(start, goal), goal)
        if not start in path:
            print(f"{byte.x},{byte.y}")
            break
