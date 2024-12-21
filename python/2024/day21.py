sample = """
029A
980A
179A
456A
379A
""".strip().splitlines()

with open("day21.input") as file:
    input = [line.strip() for line in file]

# input = sample

keypad = {
    "A-0": "<",
    "A-1": "^<<",
    "A-2": "<^",
    "A-3": "^",
    "A-4": "^^<<",
    "A-5": "<^^",
    "A-6": "^^",
    "A-7": "^^^<<",
    "A-8": "<^^^",
    "A-9": "^^^",
    "0-A": ">",
    "0-1": "^<",
    "0-2": "^",
    "0-3": "^>",
    "0-4": "^^<",
    "0-5": "^^",
    "0-6": "^^>",
    "0-7": "^^^<",
    "0-8": "^^^",
    "0-9": ">^^^",
    "1-A": ">>v",
    "1-0": ">v",
    "1-1": "",
    "1-2": ">",
    "1-3": ">>",
    "1-4": "^",
    "1-5": "^>",
    "1-6": "^>>",
    "1-7": "^^",
    "1-8": "^^>",
    "1-9": "^^>>",
    "2-A": "v>",
    "2-0": "v",
    "2-1": "<",
    "2-2": "",
    "2-3": ">",
    "2-4": "<^",
    "2-5": "^",
    "2-6": "^>",
    "2-7": "<^^",
    "2-8": "^^",
    "2-9": "^^>",
    "3-A": "v",
    "3-0": "v<",
    "3-1": "<<",
    "3-2": "<",
    "3-3": "",
    "3-4": "<<^",
    "3-5": "<^",
    "3-6": "^",
    "3-7": "<<^^",
    "3-8": "<^^",
    "3-9": "^^",
    "4-A": ">>vv",
    "4-0": ">vv",
    "4-1": "v",
    "4-2": "v>",
    "4-3": ">>v",
    "4-4": "",
    "4-5": ">",
    "4-6": ">>",
    "4-7": "^",
    "4-8": "^>",
    "4-9": "^>>",
    "5-A": "vv>",
    "5-0": "vv",
    "5-1": "<v",
    "5-2": "v",
    "5-3": "v>",
    "5-4": "<",
    "5-5": "",
    "5-6": ">",
    "5-7": "<^",
    "5-8": "^",
    "5-9": "^>",
    "6-A": "vv",
    "6-0": "<vv",
    "6-1": "<<v",
    "6-2": "<v",
    "6-3": "v",
    "6-4": "<<",
    "6-5": "<",
    "6-6": "",
    "6-7": "<<^",
    "6-8": "<^",
    "6-9": "^",
    "7-A": ">>vvv",
    "7-0": ">vvv",
    "7-1": "vv",
    "7-2": ">vv",
    "7-3": ">>vv",
    "7-4": "v",
    "7-5": "v>",
    "7-6": "v>>",
    "7-7": "",
    "7-8": ">",
    "7-9": ">>",
    "8-A": "vvv>",
    "8-0": "vvv",
    "8-1": "<vv",
    "8-2": "vv",
    "8-3": "vv>",
    "8-4": "<v",
    "8-5": "v",
    "8-6": "v>",
    "8-7": "<",
    "8-8": "",
    "8-9": ">",
    "9-A": "vvv",
    "9-0": "<vvv",
    "9-1": "<<vv",
    "9-2": "<vv",
    "9-3": "vv",
    "9-4": "<<v",
    "9-5": "<v",
    "9-6": "v",
    "9-7": "<<",
    "9-8": "<",
    "9-9": "",
}

directional = {
    "A-A": "",
    "A-^": "<",
    "A-<": "v<<",
    "A-v": "<v",
    "A->": "v",
    "^-A": ">",
    "^-^": "",
    "^-<": "v<",
    "^-v": "v",
    "^->": "v>",
    "<-A": ">>^",
    "<-^": ">^",
    "<-<": "",
    "<-v": ">",
    "<->": ">>",
    "v-A": "^>",
    "v-^": "^",
    "v-<": "<",
    "v-v": "",
    "v->": ">",
    ">-A": "^",
    ">-^": "<^",
    ">-<": "<<",
    ">-v": "<",
    ">->": "",
}

def path(buttons, pad):
    previous = "A"
    sequence = ""
    for button in buttons:
        sequence += pad[f"{previous}-{button}"] + "A"
        previous = button
    return sequence

sum = 0
for code in input:
    robot2 = path(code, keypad)
    robot1 = path(robot2, directional)
    me = path(robot1, directional)
    sum += len(me) * int(code[:3])

print(sum)

def recurse(pad, sequence, memo, depth, limit):
    if depth > limit: return len(sequence)
    length = 0
    for move in sequence.split("A")[:-1]:
        key = f"{depth}-{move}A"
        if not key in memo:
            memo[key] = recurse(pad, path(move + "A", pad), memo, depth + 1, limit)
        length += memo[key]
    return length

sum = 0
memo = {}
for code in input:
    presses = path(code, keypad)
    length = recurse(directional, presses, memo, 1, 25)
    sum += length * int(code[:3])

print(sum)
