defmodule Day10 do
  @sample """
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
  """

  defp input do
    # Grid.parse(@sample, &(&1 != "."))
    {:ok, lines} = File.read("2023/data/10.txt")
    Grid.parse(lines)
  end

  def part1 do
    grid = input()
    start = find_start(grid)
    loop = find_loop(grid, start)
    IO.puts(div(Enum.count(loop), 2))
  end

  defp find_start(grid) do
    Grid.all(grid)
    |> Enum.find_value(fn {position, symbol} -> if symbol == "S", do: position end)
  end

  defp find_loop(grid, {column, row} = position) do
    pipe = Grid.at(grid, column, row - 1)
    if Enum.member?(["|", "F", "7"], pipe) do
      find_loop(grid, {column, row - 1}, [position])
    else
      pipe = Grid.at(grid, column, row + 1)
      if Enum.member?(["|", "J", "L"], pipe) do
        find_loop(grid, {column, row + 1}, [position])
      else
        pipe = Grid.at(grid, column - 1, row)
        if Enum.member?(["-", "F", "L"], pipe) do
          find_loop(grid, {column - 1, row}, [position])
        else
          pipe = Grid.at(grid, column + 1, row)
          if Enum.member?(["-", "J", "7"], pipe) do
            find_loop(grid, {column + 1, row}, [position])
          end
        end
      end
    end
  end

  defp find_loop(grid, {column, row} = position, loop) do
    previous = hd(loop)
    pipe = Grid.at(grid, position)
    cond do
      pipe == "S" ->
        loop
      previous == {column, row - 1} && pipe == "|" ->
        find_loop(grid, {column, row + 1}, [position | loop])
      previous == {column, row + 1} && pipe == "|" ->
        find_loop(grid, {column, row - 1}, [position | loop])
      previous == {column - 1, row} && pipe == "-" ->
        find_loop(grid, {column + 1, row}, [position | loop])
      previous == {column + 1, row} && pipe == "-" ->
        find_loop(grid, {column - 1, row}, [position | loop])
      previous == {column, row - 1} && pipe == "J" ->
        find_loop(grid, {column - 1, row}, [position | loop])
      previous == {column - 1, row} && pipe == "J" ->
        find_loop(grid, {column, row - 1}, [position | loop])
      previous == {column, row - 1} && pipe == "L" ->
        find_loop(grid, {column + 1, row}, [position | loop])
      previous == {column + 1, row} && pipe == "L" ->
        find_loop(grid, {column, row - 1}, [position | loop])
      previous == {column + 1, row} && pipe == "F" ->
        find_loop(grid, {column, row + 1}, [position | loop])
      previous == {column, row + 1} && pipe == "F" ->
        find_loop(grid, {column + 1, row}, [position | loop])
      previous == {column - 1, row} && pipe == "7" ->
        find_loop(grid, {column, row + 1}, [position | loop])
      previous == {column, row + 1} && pipe == "7" ->
        find_loop(grid, {column - 1, row}, [position | loop])
    end
  end

  def part2 do
    grid = input()
    start = find_start(grid)
    loop = find_loop(grid, start)
    Enum.map(0..grid.row_count - 1, fn row ->
      Enum.reduce(0..grid.column_count - 1, 0, fn column, count ->
        count + inside_loop(loop, {column, row})
      end)
    end)
    |> Enum.sum
    |> IO.puts
  end

  defp inside_loop(loop, position) do
    previous = Enum.at(loop, -1)
    inside_loop(loop, position, previous, false)
  end
  defp inside_loop([], _, _, true), do: 1
  defp inside_loop([], _, _, false), do: 0
  defp inside_loop([{this_column, this_row} | loop], {column, row} = position, {previous_column, previous_row}, inside) do
    cond do
      column == this_column && row == this_row ->
        0
      (this_row > row) != (previous_row > row) ->
        slope = (column - this_column) * (previous_row - this_row) - (
        previous_column - this_column) * (row - this_row)
        cond do
          slope == 0 -> 0
          (slope < 0) != (previous_row < this_row) ->
            inside_loop(loop, position, {this_column, this_row}, !inside)
          true -> inside_loop(loop, position, {this_column, this_row}, inside)
        end
      true ->
        inside_loop(loop, position, {this_column, this_row}, inside)
    end
  end
end

Day10.part1
Day10.part2
