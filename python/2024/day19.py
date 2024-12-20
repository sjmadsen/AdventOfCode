sample = """
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
""".strip().splitlines()

with open("day19.input") as file:
    input = [line.strip() for line in file]

# input = sample

towels = sorted(input[0].split(", "), key=len)

def possible(pattern):
    if pattern == "": return True
    for towel in towels:
        if pattern.endswith(towel) and possible(pattern[:-len(towel)]): return True
    return False

sum = 0
for s in input[2:]:
    if possible(s): sum += 1

print(sum)

def combinations(pattern, memo):
    if pattern == "": return 1
    if pattern in memo: return memo[pattern]
    sum = 0
    for towel in towels:
        if pattern.endswith(towel):
            matches = combinations(pattern[:-len(towel)], memo)
            memo[pattern[:-len(towel)]] = matches
            sum += matches
    return sum

sum = 0
for s in input[2:]:
    sum += combinations(s, {})

print(sum)
