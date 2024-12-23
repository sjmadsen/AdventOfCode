import itertools as it

sample = """
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
""".strip().splitlines()

with open("day23.input") as file:
    input = [line.strip() for line in file]

# input = sample

connections = {}
for line in input:
    a, b = line.split("-")
    if not a in connections: connections[a] = []
    if not b in connections: connections[b] = []
    connections[a].append(b)
    connections[b].append(a)

sets = set()
for computer, conns in connections.items():
    if len(conns) >= 2:
        for pair in it.combinations(conns, 2):
            if pair[1] in connections[pair[0]]:
                peers = list(pair)
                if any(filter(lambda x: x.startswith("t"), peers + [computer])):
                    sets.add("-".join(sorted(peers + [computer])))

print(len(sets))

def interconnected(group):
    for pair in it.combinations(group, 2):
        if not pair[1] in connections[pair[0]]: return False
    return True

party = set()
for computer, conns in connections.items():
    for group in it.combinations(conns, max(len(party), 2)):
        if interconnected(group):
            party = set([computer] + list(group))

print(",".join(sorted(list(party))))
