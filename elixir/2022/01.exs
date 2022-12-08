{:ok, lines} = File.read("2022/data/1.input")
calories_per_elf = lines
|> String.trim()
|> String.split("\n\n")
|> Enum.map(fn elf ->
  elf
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
  |> Enum.reduce(0, &+/2)
end)

max_calories = Enum.max(calories_per_elf)
IO.puts(max_calories)

top_three =
  Enum.sort(calories_per_elf, &(&1 > &2))
  |> Enum.take(3)
  |> Enum.reduce(0, &+/2)

IO.puts(top_three)
