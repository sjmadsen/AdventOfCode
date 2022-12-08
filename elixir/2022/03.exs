defmodule Day3 do
  def value(c) when c > ?a, do: c - ?a + 1
  def value(c), do: c - ?A + 27
end

File.stream!("2022/data/3.input")
|> Enum.map(&String.trim/1)
|> Enum.map(fn line ->
  {first, second} = String.split_at(line, div(String.length(line), 2))
  first = MapSet.new(String.to_charlist(first))
  second = MapSet.new(String.to_charlist(second))
  MapSet.intersection(first, second)
  |> MapSet.to_list
  |> List.first
  |> Day3.value
end)
|> Enum.reduce(0, &+/2)
|> IO.puts

File.stream!("data/3.input")
|> Enum.map(&String.trim/1)
|> Enum.chunk_every(3)
|> Enum.map(fn chunk ->
  chunk
  |> Enum.map(&String.to_charlist/1)
  |> Enum.map(&MapSet.new/1)
  |> Enum.reduce(&MapSet.intersection/2)
  |> MapSet.to_list
  |> List.first
  |> Day3.value
end)
|> Enum.reduce(0, &+/2)
|> IO.puts
