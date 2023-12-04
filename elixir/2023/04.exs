defmodule Day4 do
  @sample """
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  """

  defp input do
    {:ok, lines} = File.read("2023/data/04.txt")
    lines
    # @sample
    |> String.trim
    |> String.split("\n")
  end

  def part1 do
    input()
    |> Enum.map(fn line ->
      [_, numbers] = String.split(line, ": ")
      [winners, mine] = String.split(numbers, " | ")
      winners = String.split(winners, " ", trim: true) |> MapSet.new
      mine = String.split(mine, " ", trim: true) |> MapSet.new
      MapSet.intersection(winners, mine)
      |> MapSet.size
      |> card_value()
    end)
    |> Enum.reduce(0, &+/2)
    |> IO.puts
  end

  defp card_value(0), do: 0
  defp card_value(matches), do: Integer.pow(2, matches - 1)

  def part2 do
    input = input()
    |> Enum.map(fn line ->
      [_, numbers] = String.split(line, ": ")
      [winners, mine] = String.split(numbers, " | ")
      winners = String.split(winners, " ", trim: true) |> MapSet.new
      mine = String.split(mine, " ", trim: true) |> MapSet.new
      MapSet.intersection(winners, mine)
    end)
    cards = repeating_list(1, Enum.count(input))
    do_part2(input, cards)
    |> Enum.reduce(0, &+/2)
    |> IO.puts
  end

  defp repeating_list(_value, 0), do: []
  defp repeating_list(value, count), do: [value | repeating_list(value, count - 1)]

  defp do_part2([], _), do: []
  defp do_part2([card | input], [count | cards]) do
    cards = add_cards(cards, count, MapSet.size(card))
    [count | do_part2(input, cards)]
  end

  defp add_cards([], _increment, _count), do: []
  defp add_cards(list, _increment, 0), do: list
  defp add_cards([first | rest], increment, count) do
    [first + increment | add_cards(rest, increment, count - 1)]
  end
end

Day4.part1
Day4.part2
