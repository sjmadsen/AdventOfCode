defmodule Day17 do
  @sample """
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
  """

  defp input do
    # Grid.parse(@sample, fn _ -> true end, &String.to_integer/1)
    {:ok, lines} = File.read("2023/data/17.txt")
    Grid.parse(lines, fn _ -> true end, &String.to_integer/1)
  end

  def part1 do
    grid = input()
    find_path(grid, {1, 3})
    |> IO.puts
  end

  defp find_path(grid, {min, max}) do
    start = Point.new(0, 0)
    goal = Point.new(grid.column_count - 1, grid.row_count - 1)
    state = %{
      grid: grid,
      goal: goal,
      heap: PriorityQueue.new,
      heat_map: %{start => 0},
      visited: MapSet.new,
      min_straight: min,
      max_straight: max
    }
    find_path(state, 0, {start, Point.new(0, 0)})
  end

  defp find_path(state, heat_loss, {current, _}) when current == state.goal do
    heat_loss
  end
  defp find_path(state, heat_loss, {current, direction}) do
    if MapSet.member?(state.visited, {current, direction}) do
      {{heat_loss, move_to}, heap} = PriorityQueue.extract_min(state.heap)
      find_path(%{state | heap: heap}, heat_loss, move_to)
    else
      state = %{ state | visited: MapSet.put(state.visited, {current, direction}) }
      state = moves(direction)
      |> Enum.reduce(state, fn direction, state ->
        {state, _} = Enum.reduce(1..state.max_straight, {state, heat_loss}, fn steps, {state, heat_loss} ->
          vector = Point.mul(direction, Point.new(steps, steps))
          position = Point.add(current, vector)
          case Grid.at(state.grid, position) do
            nil -> {state, heat_loss}
            cost ->
              new_heat_loss = heat_loss + cost
              if steps >= state.min_straight do
                move_to = {position, direction}
                old_heat_loss = Map.get(state.heat_map, move_to, :infinity)
                if old_heat_loss == :infinity or new_heat_loss < old_heat_loss do
                  {%{
                    state |
                    heat_map: Map.put(state.heat_map, move_to, new_heat_loss),
                    heap: PriorityQueue.add_with_priority(state.heap, move_to, new_heat_loss)
                  }, new_heat_loss}
                else
                  {state, new_heat_loss}
                end
              else
                {state, new_heat_loss}
              end
            end
        end)
        state
      end)
      {{heat_loss, move_to}, heap} = PriorityQueue.extract_min(state.heap)
      find_path(%{state | heap: heap}, heat_loss, move_to)
    end
  end

  defp moves(direction) do
    case direction do
      %Point{x: 0, y: 0} -> [Point.new(1, 0), Point.new(0, 1)]
      %Point{x: 1, y: 0} -> [Point.new(0, 1), Point.new(0, -1)]
      %Point{x: -1, y: 0} -> [Point.new(0, 1), Point.new(0, -1)]
      %Point{x: 0, y: 1} -> [Point.new(1, 0), Point.new(-1, 0)]
      %Point{x: 0, y: -1} -> [Point.new(1, 0), Point.new(-1, 0)]
    end
  end

  def part2 do
    grid = input()
    find_path(grid, {4, 10})
    |> IO.puts
  end
end

Day17.part1
Day17.part2
