defmodule Day23 do
  @sample """
  #.#####################
  #.......#########...###
  #######.#########.#.###
  ###.....#.>.>.###.#.###
  ###v#####.#v#.###.#.###
  ###.>...#.#.#.....#...#
  ###v###.#.#.#########.#
  ###...#.#.#.......#...#
  #####.#.#.#######.#.###
  #.....#.#.#.......#...#
  #.#####.#.#.#########v#
  #.#...#...#...###...>.#
  #.#.#v#######v###.###v#
  #...#.>.#...>.>.#.###.#
  #####v#.#.###v#.#.###.#
  #.....#...#...#.#.#...#
  #.#########.###.#.#.###
  #...###...#...#...#.###
  ###.###.#.###v#####v###
  #...#...#.#.>.>.#.>.###
  #.###.###.#.###.#.#v###
  #.....###...###...#...#
  #####################.#
  """

  defp input do
    # Grid.parse(@sample, &(&1 != "#"))
    {:ok, lines} = File.read("2023/data/23.txt")
    Grid.parse(lines, &(&1 != "#"))
  end

  def part1 do
    grid = input()
    bfs(grid, MapSet.new, Point.new(1, 0), Point.new(grid.column_count - 2, grid.row_count - 1))
    |> IO.puts
  end

  defp bfs(_grid, visited, goal, goal), do: MapSet.size(visited)
  defp bfs(grid, visited, location, goal) do
    if MapSet.member?(visited, location) do
      0
    else
      visited = MapSet.put(visited, location)
      case Grid.at(grid, location) do
        "^" ->
          bfs(grid, visited, Point.add(location, Point.new(0, -1)), goal)
        ">" ->
          bfs(grid, visited, Point.add(location, Point.new(1, 0)), goal)
        "v" ->
          bfs(grid, visited, Point.add(location, Point.new(0, 1)), goal)
        "<" ->
          bfs(grid, visited, Point.add(location, Point.new(-1, 0)), goal)
        "." ->
          Grid.orthogonal(grid, location)
          |> Enum.map(fn {move_to, _} -> bfs(grid, visited, move_to, goal) end)
          |> Enum.max
      end
    end
  end

  def part2 do
    grid = input()
    start = Point.new(1, 0)
    goal = Point.new(grid.column_count - 2, grid.row_count - 1)
    graph = find_junctions(grid)
    |> find_connections(grid, start, goal)
    bfs2(graph, MapSet.new, start, goal, 0)
    |> IO.puts
  end

  defp find_junctions(grid) do
    Grid.all(grid)
    |> Enum.filter(fn {location, _} ->
      Enum.count(Grid.orthogonal(grid, location)) > 2
    end)
    |> Enum.map(fn {location, _} -> location end)
  end

  defp find_connections(junctions, grid, start, goal) do
    junctions = [start, goal | junctions]
    Enum.reduce(junctions, %{}, fn junction, graph ->
      next_junction(junctions, grid, junction)
      |> Enum.reduce(graph, fn path, graph ->
        Map.update(graph, junction, [path], &([path | &1]))
      end)
    end)
  end

  defp next_junction(junctions, grid, location) do
    Grid.orthogonal(grid, location)
    |> Enum.map(fn {neighbor, _} ->
      next_junction(junctions, grid, neighbor, MapSet.new([location]), 1)
    end)
    |> Enum.filter(&(&1 != nil))
  end
  defp next_junction(junctions, grid, location, visited, steps) do
    if Enum.member?(junctions, location) do
      {location, steps}
    else
      visited = MapSet.put(visited, location)
      neighbors = Grid.orthogonal(grid, location)
      |> Enum.map(fn {next, _} -> next end)
      |> Enum.filter(&(!MapSet.member?(visited, &1)))
      if neighbors != [], do: next_junction(junctions, grid, hd(neighbors), visited, steps + 1)
    end
  end

  defp bfs2(_graph, _visited, goal, goal, steps), do: steps
  defp bfs2(graph, visited, location, goal, steps) do
    if MapSet.member?(visited, location) do
      0
    else
      visited = MapSet.put(visited, location)
      Enum.map(Map.get(graph, location), fn {next, increment} ->
        bfs2(graph, visited, next, goal, steps + increment)
      end)
      |> Enum.max
    end
  end
end

Day23.part1
Day23.part2
