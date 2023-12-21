defmodule Day21 do
  require Integer

  @sample """
  ...........
  .....###.#.
  .###.##..#.
  ..#.#...#..
  ....#.#....
  .##..S####.
  .##..#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
  """

  defp input do
    {:ok, lines} = File.read("2023/data/21.txt")
    Grid.parse(lines)
    # Grid.parse(@sample)
  end

  def part1 do
    grid = input()
    destinations(grid, 64, [find_start(grid)])
    |> Enum.count
    |> IO.puts
  end

  defp find_start(grid) do
    Grid.all(grid)
    |> Enum.find_value(fn {position, contents} -> if contents == "S", do: position, else: nil end)
  end

  defp destinations(_grid, 0, locations), do: locations
  defp destinations(grid, steps, locations) do
    new_locations = Enum.flat_map(locations, fn location ->
      Grid.orthogonal(grid, location)
      |> Enum.filter(fn {_, contents} -> contents in [".", "S"] end)
      |> Enum.map(fn {position, _} -> position end)
    end)
    |> Enum.uniq
    destinations(grid, steps - 1, new_locations)
  end

  def part2 do
    grid = input()
    distances = bfs(grid, find_start(grid))
    odd_plots = Map.values(distances) |> Enum.count(&Integer.is_odd/1)
    odd_corners = Map.values(distances) |> Enum.count(&(Integer.is_odd(&1) && &1 > 65))
    even_plots = Map.values(distances) |> Enum.count(&Integer.is_even/1)
    even_corners = Map.values(distances) |> Enum.count(&(Integer.is_even(&1) && &1 > 65))
    n = 202300
    ((n + 1) * (n + 1) * odd_plots + (n * n) * even_plots - (n + 1) * odd_corners + n * even_corners)
    |> IO.puts
  end

  defp bfs(grid, start), do: bfs(grid, [{start, 0}], %{})
  defp bfs(_grid, [], distances), do: distances
  defp bfs(grid, [{position, distance} | queue], distances) do
    distances = Map.put(distances, position, distance)
    unvisited = Grid.orthogonal(grid, position)
    |> Enum.filter(fn {neighbor, contents} ->
      contents == "." &&
      !Map.has_key?(distances, neighbor) &&
      !Enum.find(queue, fn {p, _} -> neighbor == p end)
    end)
    |> Enum.map(fn {neighbor, _} -> neighbor end)
    |> Enum.zip(Stream.cycle([distance + 1]))
    bfs(grid, queue ++ unvisited, distances)
  end
end

Day21.part1
Day21.part2
