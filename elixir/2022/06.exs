defmodule Day6 do
  def part1(string), do: find_unique_suffix(string, 3, 4)

  def part2(string), do: find_unique_suffix(string, 13, 14)

  defp find_unique_suffix(string, index, count) do
    unique = string
    |> String.slice(index, count)
    |> String.to_charlist
    |> MapSet.new
    if Enum.count(unique) == count do
      index + count
    else
      find_unique_suffix(string, index + 1, count)
    end
  end
end

input = File.read!("2022/data/6.input")

input
|> Day6.part1
|> IO.puts

input
|> Day6.part2
|> IO.puts
