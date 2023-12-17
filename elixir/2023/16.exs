defmodule Day16 do
  @sample """
  .|...\\....
  |.-.\\.....
  .....|-...
  ........|.
  ..........
  .........\\
  ..../.\\\\..
  .-.-/..|..
  .|....-|.\\
  ..//.|....
  """

  defp input do
    # Grid.parse(@sample)
    {:ok, lines} = File.read("2023/data/16.txt")
    Grid.parse(lines)
  end

  def part1 do
    input()
    |> trace_beam(MapSet.new, {0, 0}, :right)
    |> Enum.map(fn {position, _direction} -> position end)
    |> Enum.uniq
    |> Enum.count
    |> IO.puts
  end

  defp trace_beam(grid, energized, {column, row}, _direction) when column < 0 or column == grid.column_count or row < 0 or row == grid.row_count, do: energized
  defp trace_beam(grid, energized, position, direction) do
    # IO.inspect([position, direction, Grid.at(grid, position)])
    if MapSet.member?(energized, {position, direction}) do
      energized
    else
      energized = MapSet.put(energized, {position, direction})
      trace_beam(grid, energized, position, direction, Grid.at(grid, position))
    end
  end
  defp trace_beam(grid, energized, position, direction, ".") do
    trace_beam(grid, energized, move(position, direction), direction)
  end
  defp trace_beam(grid, energized, position, direction, mirror) when mirror in ["/", "\\"] do
    direction = reflect(mirror, direction)
    trace_beam(grid, energized, move(position, direction), direction)
  end
  defp trace_beam(grid, energized, position, direction, "|") when direction in [:up, :down] do
    trace_beam(grid, energized, move(position, direction), direction)
  end
  defp trace_beam(grid, energized, position, direction, "|") when direction in [:left, :right] do
    energized = trace_beam(grid, energized, move(position, :up), :up)
    trace_beam(grid, energized, move(position, :down), :down)
  end
  defp trace_beam(grid, energized, position, direction, "-") when direction in [:up, :down] do
    energized = trace_beam(grid, energized, move(position, :left), :left)
    trace_beam(grid, energized, move(position, :right), :right)
  end
  defp trace_beam(grid, energized, position, direction, "-") when direction in [:left, :right] do
    trace_beam(grid, energized, move(position, direction), direction)
  end

  defp move({column, row}, :up), do: {column, row - 1}
  defp move({column, row}, :down), do: {column, row + 1}
  defp move({column, row}, :left), do: {column - 1, row}
  defp move({column, row}, :right), do: {column + 1, row}

  defp reflect("\\", :up), do: :left
  defp reflect("\\", :down), do: :right
  defp reflect("\\", :left), do: :up
  defp reflect("\\", :right), do: :down
  defp reflect("/", :up), do: :right
  defp reflect("/", :down), do: :left
  defp reflect("/", :left), do: :down
  defp reflect("/", :right), do: :up

  def part2 do
    grid = input()
    Enum.map(start_points(grid), fn {position, direction} ->
      trace_beam(grid, MapSet.new, position, direction)
      |> Enum.map(fn {position, _direction} -> position end)
      |> Enum.uniq
      |> Enum.count
    end)
    |> Enum.max
    |> IO.puts
  end

  defp start_points(grid) do
    for col <- 0..(grid.column_count - 1) do
      [{{col, 0}, :down}, {{col, grid.row_count - 1}, :up}]
    end ++
    for row <- 0..(grid.row_count - 1) do
      [{{0, row}, :right}, {{grid.column_count - 1, row}, :left}]
    end
    |> Enum.flat_map(&(&1))
  end
end

Day16.part1
Day16.part2
