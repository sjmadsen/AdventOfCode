defmodule Day7 do
  @sample """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  @strengths %{"A" => 0, "K" => 1, "Q" => 2, "J" => 3, "T" => 4, "9" => 5, "8" => 6, "7" => 7, "6" => 8, "5" => 9, "4" => 10, "3" => 11, "2" => 12}
  @joker_strengths %{"A" => 0, "K" => 1, "Q" => 2, "J" => 13, "T" => 4, "9" => 5, "8" => 6, "7" => 7, "6" => 8, "5" => 9, "4" => 10, "3" => 11, "2" => 12}

  defp input do
    {:ok, lines} = File.read("2023/data/07.txt")
    lines
    # @sample
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ")
      {hand, String.to_integer(bid)}
    end)
  end

  def part1 do
    input()
    |> Enum.sort(fn {hand1, _}, {hand2, _} ->
      type1 = hand_type(hand1)
      type2 = hand_type(hand2)
      cond do
        type1 > type2 -> false
        type1 < type2 -> true
        true -> tie_break(@strengths, Enum.zip(String.graphemes(hand1), String.graphemes(hand2)))
      end
    end)
    |> Enum.with_index
    |> Enum.map(fn {{_, rank}, index} -> rank * (index + 1) end)
    |> Enum.sum
    |> IO.puts
  end

  defp hand_type(hand) do
    counts = count_cards(hand)
    |> Enum.reduce([], fn {_, value}, counts -> [value | counts] end)
    |> Enum.sort(:desc)
    case counts do
      [5]          -> 6
      [4, 1]       -> 5
      [3, 2]       -> 4
      [3, 1, 1]    -> 3
      [2, 2, 1]    -> 2
      [2, 1, 1, 1] -> 1
      _            -> 0
    end
  end

  defp count_cards(hand) do
    String.graphemes(hand)
    |> Enum.reduce(%{}, fn card, cards ->
      Map.update(cards, card, 1, fn value -> value + 1 end)
    end)
  end

  defp tie_break(_, []), do: true
  defp tie_break(strengths, [{card1, card2} | rest]) do
    s1 = Map.fetch(strengths, card1)
    s2 = Map.fetch(strengths, card2)
    case {s1, s2} do
      {a, b} when a == b -> tie_break(strengths, rest)
      {a, b} when a < b  -> false
      _                  -> true
    end
  end

  def part2 do
    input()
    |> Enum.sort(fn {hand1, _}, {hand2, _} ->
      type1 = best_hand_type(hand1)
      type2 = best_hand_type(hand2)
      cond do
        type1 > type2 -> false
        type1 < type2 -> true
        true -> tie_break(@joker_strengths, Enum.zip(String.graphemes(hand1), String.graphemes(hand2)))
      end
    end)
    |> Enum.with_index
    |> Enum.map(fn {{_, rank}, index} -> rank * (index + 1) end)
    |> Enum.sum
    |> IO.puts
  end

  defp best_hand_type(hand) do
    counts = count_cards(hand)
    case Map.get(counts, "J", 0) do
      0 -> hand_type(hand)
      5 -> 6
      _ ->
        counts = Map.delete(counts, "J")
        {act_as, _} = Enum.max_by(counts, fn {_, number} -> number end)
        hand_type(String.replace(hand, "J", act_as))
    end
  end
end

Day7.part1
Day7.part2
