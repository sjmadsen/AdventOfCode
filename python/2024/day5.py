import functools as ft

sample = """47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47""".splitlines()

with open("day5.input") as file:
    input = [line.rstrip() for line in file]

# input = sample

def is_sorted(pages):
    pages_ = sorted(pages, key=ft.cmp_to_key(compare_pages))
    return pages == sorted(pages, key=ft.cmp_to_key(compare_pages))

def compare_pages(a, b):
    if a in ordering:
        return -1 if b in ordering[a] else 1
    return 0

i = input.index("")
ordering = {}
for line in input[:i]:
    pair = [int(x) for x in line.split("|")]
    if pair[0] in ordering:
        ordering[pair[0]].append(pair[1])
    else:
        ordering[pair[0]] = [pair[1]]

incorrect = []
sum = 0
for line in input[i + 1:]:
    pages = [int(x) for x in line.split(",")]
    if is_sorted(pages):
        sum += pages[int(len(pages) / 2)]
    else:
        incorrect.append(pages)

print(sum)

sum = 0
for pages in incorrect:
    corrected = sorted(pages, key=ft.cmp_to_key(compare_pages))
    sum += corrected[int(len(corrected) / 2)]

print(sum)
