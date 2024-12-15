import copy
import math
import statistics

sample = """
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
""".strip().splitlines()

with open("day14.input") as file:
    input = [line.strip() for line in file]

width = 101
height = 103

# input = sample
# width = 11
# height = 7

class Robot:
    x = 0
    y = 0
    vx = 0
    vy = 0

initial_robots = []
for line in input:
    parts = line.split(" ")
    robot = Robot()
    robot.x, robot.y = [int(x) for x in parts[0][2:].split(",")]
    robot.vx, robot.vy = [int(x) for x in parts[1][2:].split(",")]
    initial_robots.append(robot)

def move(robot):
    robot.x = (robot.x + robot.vx) % width
    robot.y = (robot.y + robot.vy) % height

def print_grid(robots):
    grid = [["." for _ in range(width)] for _ in range(height)]
    for robot in robots:
        grid[robot.y][robot.x] = "*"
    print("\n".join(["".join(grid[y]) for y in range(height)]))

robots = copy.deepcopy(initial_robots)
for i in range(100):
    for robot in robots: move(robot)
    print(i, statistics.variance([robot.x for robot in robots]), statistics.variance([robot.y for robot in robots]))
    if statistics.variance([robot.x for robot in robots]) < 420:
        print_grid(robots)
    if statistics.variance([robot.y for robot in robots]) < 400:
        print_grid(robots)

def score_by_quadrant(robots):
    q1 = 0
    q2 = 0
    q3 = 0
    q4 = 0
    mid_x = math.floor(width / 2)
    mid_y = math.floor(height / 2)
    for robot in robots:
        if robot.x < mid_x and robot.y < mid_y: q1 += 1
        if robot.x > mid_x and robot.y < mid_y: q2 += 1
        if robot.x < mid_x and robot.y > mid_y: q3 += 1
        if robot.x > mid_x and robot.y > mid_y: q4 += 1
    return (q1, q2, q3, q4)

def score(robots):
    q1, q2, q3, q4 = score_by_quadrant(robots)
    return q1 * q2 * q3 * q4

print(score(robots))

robots = copy.deepcopy(initial_robots)
for i in range(1000000000):
    for robot in robots: move(robot)
    q1, q2, q3, q4 = score_by_quadrant(robots)
    if q1 + q3 + q4 < q2:
        print_grid(robots)
        print(i + 1)
        break
