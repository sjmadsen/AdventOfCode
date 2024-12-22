from collections import Counter

sample = """
1
2
3
2024
""".strip().splitlines()

with open("day22.input") as file:
    input = [line.strip() for line in file]

# input = sample

prune = (1 << 24) - 1

def next_random(x):
    x = (x ^ (x << 6)) & prune
    x = (x ^ (x >> 5)) & prune
    x = (x ^ (x << 11)) & prune
    return x

prices = []
deltas = []
sum = 0
for i, line in enumerate(input):
    x = int(line)
    prices.append([])
    deltas.append([])
    for j in range(2000):
        next = next_random(x)
        price = next % 10
        prices[i].append(price)
        deltas[i].append(price - (x % 10))
        x = next
    sum += x

print(sum)

def subindex(seq, sub):
    i = 0
    while i < len(seq) - len(sub):
        try:
            j = seq.index(sub[0], i)
            if seq[j:j + len(sub)] == sub: return j
            i += 1
        except:
            break
    return None

occurs_in = Counter()
for i in range(len(prices)):
    seen_here = set()
    for j in range(1996):
        sub = deltas[i][j:j + 4]
        if not tuple(sub) in seen_here:
            seen_here.add(tuple(sub))
            occurs_in[tuple(sub)] += 1

max = 0
for n, elem in enumerate(occurs_in.most_common()):
    sub, count = elem
    sub = list(sub)
    if count * 9 < max: break
    total = 0
    for i in range(len(prices)):
        if total + (len(prices) - i) * 9 <= max: break
        j = subindex(deltas[i], sub)
        if j: total += prices[i][j + 3]
    if total > max:
        max = total

print(max)
