import re

sample = ["xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"]

with open("day3.input") as file:
    input = [line.rstrip() for line in file]

p = re.compile(r"mul\((\d{1,3}),(\d{1,3})\)")
sum = 0
for line in input:
    for m in p.finditer(line):
        sum += int(m.group(1)) * int(m.group(2))

print(sum)

sample = ["xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"]
p = re.compile(r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)")
sum = 0
do_mul = True
for line in input:
    for m in p.finditer(line):
        match m.group():
            case "do()":
                do_mul = True
            case "don't()":
                do_mul = False
            case _:
                if do_mul:
                    sum += int(m.group(1)) * int(m.group(2))

print(sum)
