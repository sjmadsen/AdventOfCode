import io

sample = """3   4
4   3
2   5
1   3
3   9
3   3""".split("\n")

with open("day1.input") as file:
    input = [line.rstrip() for line in file]

list1 = []
list2 = []
for line in input:
    [first, second] = line.split()
    list1.append(int(first))
    list2.append(int(second))

distance = 0
for pair in zip(sorted(list1), sorted(list2)):
    distance += abs(pair[0] - pair[1])

print(distance)

similarity = 0
for item in list1:
    similarity += item * list2.count(item)

print(similarity)
