sample = """
Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
""".strip().splitlines()

with open("day17.input") as file:
    input = [line.strip() for line in file]

# input = sample

reg_a = int(input[0].split(": ")[1])
reg_b = int(input[1].split(": ")[1])
reg_c = int(input[2].split(": ")[1])
program = [int(x) for x in input[4].split(": ")[1].split(",")]

def run(program, reg_a, reg_b, reg_c):
    def combo(operand):
        if operand <= 3: return operand
        if operand == 4: return reg_a
        if operand == 5: return reg_b
        if operand == 6: return reg_c

    ip = 0
    output = []
    while ip < len(program):
        operand = program[ip + 1]
        match program[ip]:
            case 0:  # adv
                reg_a = reg_a >> combo(operand)
            case 1:  # bxl
                reg_b = reg_b ^ operand
            case 2:  # bst
                reg_b = combo(operand) & 0b111
            case 3:  # jnz
                if reg_a != 0:
                    ip = operand
                    continue
            case 4:  # bxc
                reg_b = reg_b ^ reg_c
            case 5:  # out
                output.append(combo(operand) & 0b111)
            case 6:  # bdv
                reg_b = reg_a >> combo(operand)
            case 7:  # cdv
                reg_c = reg_a  >> combo(operand)
        ip += 2
    return output

print(",".join([str(x) for x in run(program, reg_a, reg_b, reg_c)]))

a = 0
length = 1
while True:
    output = run(program, a, reg_b, reg_c)
    if output == program:
        break
    if output == program[-length:]:
        a <<= 3
        length += 1
        continue
    a += 1

print(a)
