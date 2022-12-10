defmodule Day10 do
  def make_rope(1, value), do: [value]
  def make_rope(length, value), do: [value | make_rope(length - 1, value)]

  def move(_direction, 0, rope, visited), do: {rope, visited}
  def move("U", distance, [head = %Point{} | rest], visited) do
    head = %Point{x: head.x, y: head.y + 1}
    {rope, visited} = drag_trailing(head, rest, visited)
    move("U", distance - 1, rope, visited)
  end
  def move("D", distance, [head = %Point{} | rest], visited) do
    head = %Point{x: head.x, y: head.y - 1}
    {rope, visited} = drag_trailing(head, rest, visited)
    move("D", distance - 1, rope, visited)
  end
  def move("L", distance, [head = %Point{} | rest], visited) do
    head = %Point{x: head.x - 1, y: head.y}
    {rope, visited} = drag_trailing(head, rest, visited)
    move("L", distance - 1, rope, visited)
  end
  def move("R", distance, [head = %Point{} | rest], visited) do
    head = %Point{x: head.x + 1, y: head.y}
    {rope, visited} = drag_trailing(head, rest, visited)
    move("R", distance - 1, rope, visited)
  end

  defp drag_trailing(point = %Point{}, [], visited), do: {[point], MapSet.put(visited, point)}
  defp drag_trailing(leader = %Point{}, [point = %Point{} | rest], visited) do
    point = catch_up(point, leader)
    {rest, visited} = drag_trailing(point, rest, visited)
    {[leader | rest], visited}
  end

  defp catch_up(point = %Point{x: point_x, y: point_y}, %Point{x: leader_x, y: leader_y}) when point_x == leader_x and point_y == leader_y do
    point
  end
  defp catch_up(point = %Point{x: point_x}, leader = %Point{x: leader_x}) when point_x == leader_x do
    gap = leader.y - point.y
    if abs(gap) > 1 do
      %Point{x: point_x, y: point.y + div(abs(gap), gap)}
    else
      point
    end
  end
  defp catch_up(point = %Point{y: point_y}, leader = %Point{y: leader_y}) when point_y == leader_y do
    gap = leader.x - point.x
    if abs(gap) > 1 do
      %Point{x: point.x + div(abs(gap), gap), y: point.y}
    else
      point
    end
  end
  defp catch_up(point = %Point{}, leader = %Point{}) do
    x_gap = leader.x - point.x
    y_gap = leader.y - point.y
    if abs(x_gap) + abs(y_gap) > 2 do
      %Point{x: point.x + div(abs(x_gap), x_gap), y: point.y + div(abs(y_gap), y_gap)}
    else
      point
    end
  end
end

rope = Day10.make_rope(2, %Point{})
{_, visited} = File.stream!("2022/data/9.input")
|> Stream.map(&String.trim_trailing/1)
|> Enum.reduce({rope, MapSet.new}, fn line, {rope, visited} ->
  [direction, distance] = String.split(line, " ")
  Day10.move(direction, String.to_integer(distance), rope, visited)
end)
IO.puts(MapSet.size(visited))

rope = Day10.make_rope(10, %Point{})
{_, visited} = File.stream!("2022/data/9.input")
|> Stream.map(&String.trim_trailing/1)
|> Enum.reduce({rope, MapSet.new}, fn line, {rope, visited} ->
  [direction, distance] = String.split(line, " ")
  Day10.move(direction, String.to_integer(distance), rope, visited)
end)
IO.puts(MapSet.size(visited))
