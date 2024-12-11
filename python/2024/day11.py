from collections import Counter

sample = "125 17"

with open("day11.input") as file:
    input = file.readline().strip()

# input = sample

stones = [int(x) for x in input.split()]

def blink(before):
    after = Counter()
    for stone, count in before.items():
        if stone == 0: after[1] += count
        elif len(str(stone)) % 2 == 0:
            s = str(stone)
            mid = int(len(s) / 2)
            after[int(s[:mid])] += count
            after[int(s[mid:])] += count
        else: after[stone * 2024] += count
    return after

blinked = Counter(stones)
for _ in range(25):
    blinked = blink(blinked)

print(blinked.total())

for _ in range(50):
    blinked = blink(blinked)

print(blinked.total())
