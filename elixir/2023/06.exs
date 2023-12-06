defmodule Day6 do
  @sample """
  Time:      7  15   30
  Distance:  9  40  200
  """

  def part1 do
    {:ok, lines} = File.read("2023/data/06.txt")
    lines
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip
    |> Enum.map(fn {duration, record} ->
      distances(duration)
      |> Enum.count(&(&1 > record))
    end)
    |> Enum.reduce(1, &*/2)
    |> IO.puts
  end

  defp distances(duration) do
    1..(duration - 1)
    |> Enum.map(fn acceleration ->
      (duration - acceleration) * acceleration
    end)
  end

  def part2 do
    {:ok, lines} = File.read("2023/data/06.txt")
    [duration, record] = lines
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.drop(1)
      |> Enum.join
      |> String.to_integer
    end)

    distances(duration)
    |> Enum.count(&(&1 > record))
    |> IO.puts
  end
end

Day6.part1
Day6.part2
