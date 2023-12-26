defmodule Day24 do
  @sample """
  19, 13, 30 @ -2,  1, -2
  18, 19, 22 @ -1, -1, -2
  20, 25, 34 @ -2, -2, -4
  12, 31, 28 @ -1, -2, -1
  20, 19, 15 @  1, -5, -3
  """

  defp input do
    # Input.from_string(@sample)
    Input.from_file("2023/data/24.txt")
    |> Enum.map(fn line ->
      String.split(line, " @ ")
      |> Enum.map(fn coords ->
        [x, y, z] = String.split(coords, ",")
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        Point3.new(x, y, z)
      end)
      |> List.to_tuple
    end)
  end

  def part1 do
    input()
    |> Combination.combine(2)
    |> Enum.map(fn [a, b] ->
      intersection(a, b)
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.filter(fn p ->
      # p.x >= 7 && p.x <= 27 && p.y >= 7 && p.y <= 27
      p.x >= 200000000000000 && p.x <= 400000000000000 && p.y >= 200000000000000 && p.y <= 400000000000000
    end)
    |> Enum.count
    |> IO.puts
  end

  defp intersection({p1, v1}, {p3, v3}) do
    p2 = Point3.add(p1, v1)
    p4 = Point3.add(p3, v3)
    denom = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
    if denom != 0 do
      ix = ((p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / denom
      iy = ((p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) / denom
      intersection = Point.new(ix, iy)
      if in_future({p1, v1}, intersection) && in_future({p3, v3}, intersection), do: intersection
    end
  end

  defp in_future({p, v}, i) do
    compare(i.x, p.x) == compare(v.x, 0) && compare(i.y, p.y) == compare(v.y, 0)
  end

  defp compare(a, b) when a < b, do: -1
  defp compare(a, b) when a > b, do: 1
  defp compare(_, _), do: 0

  def part2 do
    input = input()
    subset = Enum.take_random(input, 4)
    [rock_v | _] = for x <- -1000..1000, y <- -1000..1000 do
      rv = Point3.new(x, y, 0)
      intersections = subset
      |> Combination.combine(2)
      |> Enum.map(fn [{a, va}, {b, vb}] ->
        va = Point3.sub(va, rv)
        vb = Point3.sub(vb, rv)
        intersection({a, va}, {b, vb})
      end)
      if same_point?(intersections), do: Point3.new(x, y, 0)
    end
    |> Enum.filter(&(&1 != nil))
    |> IO.inspect
    [{a, av}, {b, bv} | _] = subset
    av = Point3.sub(av, rock_v)
    bv = Point3.sub(bv, rock_v)
    intersect = intersection({a, av}, {b, bv})
    |> IO.inspect
    |> then(fn p -> Point.new(trunc(p.x), trunc(p.y)) end)
    extrapolate_z({a, av}, {b, bv}, intersect)
    |> IO.inspect
    |> then(fn p -> p.x + p.y + p.z end)
    |> IO.puts
  end

  defp same_point?(list) do
    value = hd(list)
    Enum.all?(list, &(&1 == value))
  end

  defp extrapolate_z({a, av}, {b, bv}, intersect) do
    rz = for z <- -1000..1000 do
      av = Point3.new(av.x, av.y, av.z - z)
      {t1, r1} = divrem(intersect.x - a.x, av.x)
      bv = Point3.new(bv.x, bv.y, bv.z - z)
      {t2, r2} = divrem(intersect.x - b.x, bv.x)
      if r1 == 0 && r2 == 0 && a.z + (av.z * t1) == b.z + (bv.z * t2), do: z
    end
    |> Enum.filter(&(&1 != nil))
    |> hd
    t = div(intersect.x - a.x, av.x)
    z = a.z + (av.z - rz) * t
    Point3.new(intersect.x, intersect.y, z)
  end

  defp divrem(a, b), do: {div(a, b), rem(a, b)}
end

Day24.part1
Day24.part2
