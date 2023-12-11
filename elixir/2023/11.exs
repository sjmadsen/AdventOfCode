defmodule Day11 do
  @sample """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  def input() do
    # Grid.parse(@sample, &(&1 != "."))
    {:ok, lines} = File.read("2023/data/11.txt")
    Grid.parse(lines, &(&1 != "."))
    |> Grid.all
    |> Enum.map(fn {position, _} -> position end)
  end

  def part1 do
    galaxies = input()
    |> expand_columns
    |> expand_rows
    Combination.combine(galaxies, 2)
    |> Enum.map(&distance/1)
    |> Enum.sum
    |> IO.puts
  end

  defp expand_columns(galaxies, amount \\ 1) do
    max_column = Enum.map(galaxies, fn {column, _} -> column end)
    |> Enum.max
    empty_columns = Enum.filter(0..max_column, fn this_column ->
      Enum.filter(galaxies, fn {column, _} -> column == this_column end)
      |> Enum.empty?
    end)
    Enum.map(galaxies, fn {column, row} ->
      offset = Enum.count(empty_columns, &(&1 < column)) * amount
      {column + offset, row}
    end)
  end

  defp expand_rows(galaxies, amount \\ 1) do
    max_row = Enum.map(galaxies, fn {_, row} -> row end)
    |> Enum.max
    empty_rows = Enum.filter(0..max_row, fn this_row ->
      Enum.filter(galaxies, fn {_, row} -> row == this_row end)
      |> Enum.empty?
    end)
    Enum.map(galaxies, fn {column, row} ->
      offset = Enum.count(empty_rows, &(&1 < row)) * amount
      {column, row + offset}
    end)
  end

  defp distance([{col1, row1}, {col2, row2}]) do
    abs(row2 - row1) + abs(col2 - col1)
  end

  def part2 do
    galaxies = input()
    |> expand_columns(999999)
    |> expand_rows(999999)
    Combination.combine(galaxies, 2)
    |> Enum.map(&distance/1)
    |> Enum.sum
    |> IO.puts
  end
end

Day11.part1
Day11.part2
