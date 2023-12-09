defmodule Day9 do
  @sample """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  defp input do
    # Input.from_string(@sample)
    Input.from_file("2023/data/09.txt")
    |> Stream.map(fn line ->
      String.split(line, " ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1 do
    input()
    |> Stream.map(&next_value/1)
    |> Stream.map(&(Enum.at(&1, -1)))
    |> Enum.sum
    |> IO.puts
  end

  defp next_value(list) do
    if Enum.all?(list, &(&1 == 0)) do
      list
    else
      differences = pairs(list)
      |> Enum.map(fn [first, second] -> second - first end)
      |> next_value
      list ++ [Enum.at(list, -1) + Enum.at(differences, -1)]
    end
  end

  defp pairs([]), do: []
  defp pairs([first, second]), do: [[first, second]]
  defp pairs([first, second | rest]) do
    [[first, second] | pairs([second | rest])]
  end

  def part2 do
    input()
    |> Stream.map(&previous_value/1)
    |> Stream.map(&(Enum.at(&1, 0)))
    |> Enum.sum
    |> IO.puts
  end

  defp previous_value(list) do
    if Enum.all?(list, &(&1 == 0)) do
      list
    else
      differences = pairs(list)
      |> Enum.map(fn [first, second] -> second - first end)
      |> previous_value
      [Enum.at(list, 0) - Enum.at(differences, 0) | list]
    end
  end
end

Day9.part1
Day9.part2
