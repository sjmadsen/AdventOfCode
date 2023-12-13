defmodule Day13 do
  @sample """
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.

  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  """

  defp input do
    # @sample
    {:ok, lines} = File.read("2023/data/13.txt")
    lines
    |> String.trim
    |> String.split("\n\n")
    |> Enum.map(&Grid.parse/1)
  end

  def part1 do
    input()
    |> Enum.map(&find_reflection/1)
    |> Enum.map(&hd/1)
    |> Enum.map(&pattern_value/1)
    |> Enum.sum
    |> IO.puts
  end

  defp find_reflection(grid) do
    contents = Enum.map(Grid.rows(grid), fn row ->
      Enum.map(row, fn {_position, contents} -> contents end)
    end)
    horizontal_slices = 0..(grid.row_count - 2)
    |> Enum.filter(&(is_mirror?(contents, &1)))
    |> Enum.map(&({:horizontal, &1 + 1}))

    contents = Enum.map(Grid.columns(grid), fn columns ->
      Enum.map(columns, fn {_position, contents} -> contents end)
    end)
    vertical_slices = 0..(grid.column_count - 2)
    |> Enum.filter(&(is_mirror?(contents, &1)))
    |> Enum.map(&({:vertical, &1 + 1}))

    horizontal_slices ++ vertical_slices
  end

  defp is_mirror?(contents, slice_at) when is_integer(slice_at) do
    first = Enum.slice(contents, 0..slice_at)
    second = Enum.slice(contents, (slice_at + 1)..-1)
    is_mirror?(Enum.reverse(first), second)
  end

  defp is_mirror?([], _), do: true
  defp is_mirror?(_, []), do: true
  defp is_mirror?([first | rest_first], [second | rest_second]) do
    cond do
      first == second ->
        is_mirror?(rest_first, rest_second)
      true ->
        false
    end
  end

  defp pattern_value({:vertical, columns}), do: columns
  defp pattern_value({:horizontal, rows}), do: rows * 100

  def part2 do
    input()
    |> Enum.map(&find_smudge/1)
    |> Enum.map(&pattern_value/1)
    |> Enum.sum
    |> IO.puts
  end

  defp find_smudge(grid) do
    original = find_reflection(grid)
    for row <- 0..(grid.row_count - 1), column <- 0..(grid.column_count - 1) do
      case Grid.at(grid, column, row) do
        "." -> Grid.update(grid, {column, row}, "#")
        "#" -> Grid.update(grid, {column, row}, ".")
      end
      |> find_reflection
    end
    |> Enum.flat_map(&(&1))
    |> Enum.filter(&([&1] != original))
    |> hd
  end
end

Day13.part1
Day13.part2
