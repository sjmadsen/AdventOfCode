import itertools as it

sample = """7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9""".split("\n")

with open("day2.input") as file:
    input = [line.rstrip() for line in file]

def is_safe(deltas):
    for d in deltas:
        if abs(d) > 3 or d == 0:
            return False
    signs = [x/abs(x) for x in deltas]
    return signs.count(signs[0]) == len(signs)

safe = 0
damped_safe = 0
for line in input:
    report = [int(x) for x in line.split()]
    deltas = [b - a for (a, b) in it.pairwise(report)]
    if is_safe(deltas):
        safe += 1
        damped_safe += 1
    else:
        subset_safe = 0
        for i in range(len(report)):
            report_copy = report.copy()
            del report_copy[i]
            deltas = [b - a for (a, b) in it.pairwise(report_copy)]
            if is_safe(deltas):
                subset_safe += 1
        if subset_safe > 0:
            damped_safe += 1

print(safe)
print(damped_safe)
