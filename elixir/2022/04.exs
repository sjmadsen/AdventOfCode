defmodule Day4 do
  def parse_ranges(line) do
    [first, second] = line
    |> String.split(",")
    |> Enum.map(fn range ->
      [low, high] = String.split(range, "-")
      Range.new(String.to_integer(low), String.to_integer(high))
    end)
    {MapSet.new(first), MapSet.new(second)}
  end
end

File.stream!("2022/data/4.input")
|> Enum.map(&String.trim/1)
|> Enum.map(&Day4.parse_ranges/1)
|> Enum.count(fn {first, second} ->
  MapSet.subset?(first, second) || MapSet.subset?(second, first)
end)
|> IO.puts

File.stream!("2022/data/4.input")
|> Enum.map(&String.trim/1)
|> Enum.map(&Day4.parse_ranges/1)
|> Enum.count(fn {first, second} ->
  !Enum.empty?(MapSet.intersection(first, second))
end)
|> IO.puts
