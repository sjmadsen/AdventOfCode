defmodule Day18 do
  @sample """
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    """

  defp input do
    # Input.from_string(@sample)
    Input.from_file("2023/data/18.txt")
    |> Enum.map(fn line ->
      [direction, count, color] = String.split(line, " ")
      {direction, String.to_integer(count), String.slice(color, 1..-2)}
    end)
  end

  def part1 do
    path = input()
    |> make_path
    shoelace(path) + perimeter(path) / 2 + 1
    |> IO.puts
  end

  defp make_path(lines) do
    Enum.reduce(lines, [Point.new(0, 0)], fn {direction, length, _}, path ->
      vector = case direction do
        "U" -> Point.new(0, length)
        "D" -> Point.new(0, -length)
        "L" -> Point.new(-length, 0)
        "R" -> Point.new(length, 0)
      end
      [Point.add(hd(path), vector) | path]
    end)
  end

  defp shoelace(path) do
    area2 = Enum.chunk_every(path ++ [hd(path)], 2, 1, :discard)
    |> Enum.map(fn [p1, p2] ->
      (p1.x * p2.y) - (p2.x * p1.y)
    end)
    |> Enum.sum
    area2 / 2
  end

  defp perimeter(path) do
    Enum.chunk_every(path ++ [hd(path)], 2, 1, :discard)
    |> Enum.map(fn [p1, p2] ->
      abs(p1.x - p2.x) + abs(p1.y - p2.y)
    end)
    |> Enum.sum
  end

  def part2 do
    path = input()
    |> Enum.map(fn {_, _, rgb} -> convert(rgb) end)
    |> make_path
    shoelace(path) + perimeter(path) / 2 + 1
    |> IO.puts
  end

  defp convert(rgb) do
    hex_meters = String.slice(rgb, 1..5)
    direction = case String.slice(rgb, 6..-1) do
      "0" -> "R"
      "1" -> "D"
      "2" -> "L"
      "3" -> "U"
    end
    {direction, String.to_integer(hex_meters, 16), rgb}
  end
end

Day18.part1
Day18.part2
