defmodule Day14 do
  @sample """
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  """

  defp input do
    # Grid.parse(@sample, &(&1 != "."))
    {:ok, lines} = File.read("2023/data/14.txt")
    Grid.parse(lines, &(&1 != "."))
  end

  def part1 do
    grid = input()
    roll(grid, :north)
    |> north_support_load
    |> IO.puts
  end

  defp north_support_load(grid) do
    Grid.rows(grid)
    |> Enum.map(fn row ->
      Enum.map(row, fn {{_, row_index}, content} ->
        if content == "O", do: grid.row_count - row_index, else: 0
      end)
      |> Enum.sum
    end)
    |> Enum.sum
  end

  defp roll(grid, :north) do
    Grid.rows(grid)
    |> do_roll(grid, :north)
  end
  defp roll(grid, :south) do
    Grid.rows(grid)
    |> Enum.reverse
    |> do_roll(grid, :south)
  end
  defp roll(grid, :west) do
    Grid.columns(grid)
    |> do_roll(grid, :west)
  end
  defp roll(grid, :east) do
    Grid.columns(grid)
    |> Enum.reverse
    |> do_roll(grid, :east)
  end
  defp do_roll(slices, grid, direction) do
    Enum.reduce(slices, grid, fn slice, grid ->
      Enum.reduce(slice, grid, fn {position, contents}, grid ->
        case contents do
          "O" ->
            new_position = roll(grid, position, direction)
            Grid.remove(grid, position)
            |> Grid.update(new_position, contents)
          _ ->
            grid
        end
      end)
    end)
  end

  defp roll(grid, {column, row}, :north) do
    cond do
      row == 0 -> {column, row}
      Grid.at(grid, {column, row - 1}) -> {column, row}
      true -> roll(grid, {column, row - 1}, :north)
    end
  end
  defp roll(grid, {column, row}, :south) do
    cond do
      row == grid.row_count - 1 -> {column, row}
      Grid.at(grid, {column, row + 1}) -> {column, row}
      true -> roll(grid, {column, row + 1}, :south)
    end
  end
  defp roll(grid, {column, row}, :west) do
    cond do
      column == 0 -> {column, row}
      Grid.at(grid, {column - 1, row}) -> {column, row}
      true -> roll(grid, {column - 1, row}, :west)
    end
  end
  defp roll(grid, {column, row}, :east) do
    cond do
      column == grid.column_count - 1 -> {column, row}
      Grid.at(grid, {column + 1, row}) -> {column, row}
      true -> roll(grid, {column + 1, row}, :east)
    end
  end

  def part2 do
    input()
    |> cycle(0, %{})
    |> north_support_load
    |> IO.puts
  end

  defp cycle(grid, 1000000000, _), do: grid
  defp cycle(grid, iteration, cache) do
    last_iteration = Map.get(cache, grid)
    cond do
      last_iteration != nil &&
      iteration + (iteration - last_iteration) <= 1000000000 ->
        cycle(grid, iteration + (iteration - last_iteration), cache)
      true ->
        cache = Map.put(cache, grid, iteration)
        grid
        |> roll(:north)
        |> roll(:west)
        |> roll(:south)
        |> roll(:east)
        |> cycle(iteration + 1, cache)
    end
  end
end

Day14.part1
Day14.part2
