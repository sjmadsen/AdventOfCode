defmodule Path2d do
  def area([%Point{} | _] = path) do
    twice_area = Enum.chunk_every(path ++ [hd(path)], 2, 1, :discard)
    |> Enum.map(fn [p1, p2] ->
      (p1.x * p2.y) - (p2.x * p1.y)
    end)
    |> Enum.sum
    abs(twice_area / 2)
  end

  def perimeter([%Point{} | _] = path) do
    Enum.chunk_every(path ++ [hd(path)], 2, 1, :discard)
    |> Enum.map(fn [p1, p2] ->
      abs(p1.x - p2.x) + abs(p1.y - p2.y)
    end)
    |> Enum.sum
  end

end
