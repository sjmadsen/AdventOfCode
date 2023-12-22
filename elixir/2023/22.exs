defmodule Day22 do
  @sample """
  1,0,1~1,2,1
  0,0,2~2,0,2
  0,2,3~2,2,3
  0,0,4~0,2,4
  2,0,5~2,2,5
  0,1,6~2,1,6
  1,1,8~1,1,9
  """

  defp input do
    # Input.from_string(@sample)
    Input.from_file("2023/data/22.txt")
    |> Enum.map(fn line ->
      String.split(line, "~")
      |> Enum.map(fn point ->
        [x, y, z] = String.split(point, ",")
        |> Enum.map(&String.to_integer/1)
        Point3.new(x, y, z)
      end)
      |> List.to_tuple
      |> position_and_size
    end)
    |> sort
  end

  defp position_and_size({%Point3{} = p1, %Point3{} = p2}) when p1.x != p2.x do
    point = if p1.x < p2.x, do: p1, else: p2
    {point, Point3.new(abs(p1.x - p2.x) + 1, 1, 1)}
  end
  defp position_and_size({%Point3{} = p1, %Point3{} = p2}) when p1.y != p2.y do
    point = if p1.y < p2.y, do: p1, else: p2
    {point, Point3.new(1, abs(p1.y - p2.y) + 1, 1)}
  end
  defp position_and_size({%Point3{} = p1, %Point3{} = p2}) when p1.z != p2.z do
    point = if p1.z < p2.z, do: p1, else: p2
    {point, Point3.new(1, 1, abs(p1.z - p2.z) + 1)}
  end
  defp position_and_size({p1, _p2}), do: {p1, Point3.new(1, 1, 1)}

  defp sort(bricks) do
    Enum.sort(bricks, fn {p1, _}, {p2, _} -> p1.z > p2.z end)
  end

  def part1 do
    bricks = input()
    |> fall
    {supports, supported_by} = find_supports(bricks)
    Enum.count(supports, fn {_brick, others} ->
      Enum.all?(others, fn other ->
        Enum.count(Map.get(supported_by, other, [])) > 1
      end)
    end)
    |> IO.puts
  end

  defp fall([]), do: []
  defp fall([brick | below]) do
    below = fall(below)
    [fall(below, brick) | below]
  end

  defp fall(_bricks, {%Point3{x: _, y: _, z: 1}, _} = brick), do: brick
  defp fall(bricks, {position, size} = brick) do
    new_z = Enum.reduce_while(bricks, 1, fn {other_position, other_size} = other, max_z ->
      cond do
        brick == other ->
          {:halt, max_z}
        overlap?(brick, other) ->
          {:cont, max(max_z, other_position.z + other_size.z)}
        true ->
          {:cont, max_z}
      end
    end)
    {%Point3{position | z: new_z}, size}
  end

  defp overlap?({p1, s1}, {p2, s2}) do
    xs1 = p1.x..(p1.x + s1.x - 1)
    xs2 = p2.x..(p2.x + s2.x - 1)
    ys1 = p1.y..(p1.y + s1.y - 1)
    ys2 = p2.y..(p2.y + s2.y - 1)
    !Range.disjoint?(xs1, xs2) && !Range.disjoint?(ys1, ys2)
  end

  defp find_supports([]), do: {%{}, %{}}
  defp find_supports([brick | below]) do
    {supports, supported_by} = find_supports(below)
    {supports, supported_by} = Enum.reduce(below, {supports, supported_by}, fn other, {supports, supported_by} ->
      {brick_position, _} = brick
      {other_position, other_size} = other
      if overlap?(brick, other) && brick_position.z == other_position.z + other_size.z do
        {Map.update(supports, other, [brick], &([brick | &1])), Map.update(supported_by, brick, [other], &([other | &1]))}
      else
        {supports, supported_by}
      end
    end)
    {Map.put(supports, brick, []), supported_by}
  end

  def part2 do
    bricks = input()
    |> fall
    {supports, supported_by} = find_supports(bricks)
    Enum.map(bricks, fn brick ->
      (get_chain(supports, supported_by, brick, MapSet.new([brick]))
       |> MapSet.size()) - 1
    end)
    |> Enum.sum
    |> IO.puts
  end

  defp get_chain(supports, supported_by, brick, chain) do
    unsupported = Enum.reduce(Map.get(supports, brick, []), [], fn other, unsupported ->
      if Enum.all?(Map.get(supported_by, other), &(MapSet.member?(chain, &1))) do
        [other | unsupported]
      else
        unsupported
      end
    end)
    chain = MapSet.union(chain, MapSet.new(unsupported))
    Enum.reduce(unsupported, chain, fn other, chain ->
      get_chain(supports, supported_by, other, chain)
    end)
  end
end

Day22.part1
Day22.part2
