defmodule Day3 do
  @sample """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  defp input do
    {:ok, lines} = File.read("2023/data/03.txt")
    lines
    # @sample
    |> String.trim
    |> String.split("\n")
  end

  def part1 do
    input = input()
    symbols = find_symbols(input)
    input
    |> Enum.with_index
    |> Enum.map(fn {row, row_index} ->
      String.graphemes(row)
      |> Enum.with_index
      |> part_numbers(row_index, symbols)
      |> Enum.reduce(0, &+/2)
    end)
    |> Enum.reduce(0, &+/2)
    |> IO.puts
  end

  defp find_symbols(input) do
    input
    |> Enum.with_index
    |> Enum.reduce(MapSet.new, fn {row, row_index}, symbols ->
      String.graphemes(row)
      |> Enum.with_index
      |> Enum.reduce(symbols, fn {character, col_index}, symbols ->
        insert(symbols, character, {col_index, row_index})
      end)
    end)
  end

  defguardp is_digit(term) when term in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

  defp insert(symbols, character, _position) when is_digit(character), do: symbols
  defp insert(symbols, ".", _position), do: symbols
  defp insert(symbols, _character, position) do
    MapSet.put(symbols, position)
  end

  defp part_numbers(row, row_index, symbols) do
    part_numbers([], row, row_index, symbols, "", false)
  end
  defp part_numbers(found, [], _row_index, _symbols, "", _is_part_number), do: found
  defp part_numbers(found, [], _row_index, _symbols, partial, true) do
    [String.to_integer(partial) | found]
  end
  defp part_numbers(found, [], _row_index, _symbols, _partial, false), do: found
  defp part_numbers(found, [{number, col_index} | row], row_index, symbols, partial, is_part_number) when is_digit(number) do
    part_numbers(found, row, row_index, symbols, partial <> number, is_part_number || symbol_adjacent(symbols, {col_index, row_index}))
  end
  defp part_numbers(found, [_ | row], row_index, symbols, partial, true) do
    part_numbers([String.to_integer(partial) | found], row, row_index, symbols, "", false)
  end
  defp part_numbers(found, [_ | row], row_index, symbols, _, _) do
    part_numbers(found, row, row_index, symbols, "", false)
  end

  def symbol_adjacent(symbols, {col_index, row_index}) do
    MapSet.member?(symbols, {col_index - 1, row_index - 1})
    || MapSet.member?(symbols, {col_index, row_index - 1})
    || MapSet.member?(symbols, {col_index + 1, row_index - 1})
    || MapSet.member?(symbols, {col_index - 1, row_index})
    || MapSet.member?(symbols, {col_index + 1, row_index})
    || MapSet.member?(symbols, {col_index - 1, row_index + 1})
    || MapSet.member?(symbols, {col_index, row_index + 1})
    || MapSet.member?(symbols, {col_index + 1, row_index + 1})
  end

  def part2 do
    input = input()
    gears = find_gears(input)
    find_each_gear_parts(input, gears)
    |> Enum.filter(&(Enum.count(&1) == 2))
    |> Enum.map(fn parts ->
      Enum.reduce(parts, 1, &*/2)
    end)
    |> Enum.reduce(0, &+/2)
    |> IO.puts
  end

  defp find_gears(input) do
    input
    |> Enum.with_index
    |> Enum.reduce(MapSet.new, fn {row, row_index}, gears ->
      String.graphemes(row)
      |> Enum.with_index
      |> Enum.reduce(gears, fn {character, col_index}, gears ->
        case character do
          "*" -> MapSet.put(gears, {col_index, row_index})
          _   -> gears
        end
      end)
    end)
  end

  defp find_each_gear_parts(input, gears) do
    Enum.map(gears, fn gear ->
      find_gear_parts(input, gear)
    end)
  end
  defp find_gear_parts(input, {_, row_index} = gear) do
    find_gear_parts(Enum.at(input, row_index - 1, []), row_index - 1, MapSet.new([gear])) ++
    find_gear_parts(Enum.at(input, row_index, []), row_index, MapSet.new([gear])) ++
    find_gear_parts(Enum.at(input, row_index + 1, []), row_index + 1, MapSet.new([gear]))
  end
  defp find_gear_parts(line, row_index, gear) do
    String.graphemes(line)
    |> Enum.with_index
    |> part_numbers(row_index, gear)
  end
end

Day3.part1
Day3.part2
