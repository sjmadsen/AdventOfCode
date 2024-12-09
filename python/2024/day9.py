sample = "2333133121414131402"

with open("day9.input") as file:
    input = file.readline().strip()

# input = sample

blocks = []
files = []
free = []
file = True
id = 0
index = 0
for char in input:
    size = int(char)
    if file:
        blocks.extend([id for x in range(size)])
        files.append((index, id, size))
        id += 1
        index += size
    else:
        blocks.extend(["." for x in range(size)])
        free.append((index, size))
        index += size
    file = not file

i = 0
j = len(blocks) - 1
sum = 0
while i <= j:
    if blocks[i] != ".":
        sum += i * blocks[i]
        i += 1
        continue
    if blocks[j] == ".":
        j -= 1
        continue

    blocks[i] = blocks[j]
    sum += i * blocks[i]
    blocks[j] = "."
    i += 1
    j -= 1

print(sum)

i = len(files) - 1
while i > 0:
    index, id, size = files[i]
    for j, block in enumerate(free):
        free_index, free_size = block
        if free_size >= size and free_index < index:
            files[i] = (free_index, id, size)
            if free_size > size:
                free[j] = (free_index + size, free_size - size)
            else:
                del free[j]
            break
    i -= 1

sum = 0
for file in files:
    index, id, size = file
    for i in range(size):
        sum += (index + i) * id

print(sum)
