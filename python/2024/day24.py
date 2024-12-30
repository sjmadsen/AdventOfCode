sample = """
x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj
""".strip().splitlines()

with open("day24.input") as file:
    input = [line.strip() for line in file]

# input = sample

blank = input.index("")

wires = {}
for line in input[:blank]:
    wire, value = line.split(": ")
    wires[wire] = True if value == "1" else False

outputs = {}
bits = 0
for line in input[blank + 1:]:
    i1, op, i2, _, output = line.split(" ")
    outputs[output] = (i1, op, i2)
    if output.startswith("z"):
        bits = max(bits, int(output[1:]) + 1)

def solve(wire):
    if not wire in wires:
        (i1, op, i2) = outputs[wire]
        solve(i1)
        solve(i2)
        if i1 in wires and i2 in wires:
            if op == "AND": wires[wire] = wires[i1] and wires[i2]
            elif op == "OR": wires[wire] = wires[i1] or wires[i2]
            elif op == "XOR": wires[wire] = wires[i1] != wires[i2]

while True:
    for bit in range(bits):
        loop = False
        wire = f"z{bit:02}"
        if not wire in wires:
            solve(wire)
            loop = True
    if not loop: break

answer = 0
for bit in range(bits):
    wire = f"z{bit:02}"
    answer |= int(wires[wire]) << bit

print(answer)

print("strict digraph {")
for wire in outputs:
    i1, op, i2 = outputs[wire]
    print(f"{i1} -> {wire} [label={op}]")
    print(f"{i2} -> {wire} [label={op}]")
print("}")
