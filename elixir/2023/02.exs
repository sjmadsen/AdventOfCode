defmodule Day2 do
  @sample """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """

  defp input do
    {:ok, lines} = File.read("2023/data/02.txt")
    lines
    |> String.trim
    |> String.split("\n")
  end

  def match_to_int(nil), do: 0
  def match_to_int(s), do: List.last(s) |> String.to_integer

  def part1 do
    input()
    |> Enum.map(fn line ->
      [_, game, draws] = Regex.run(~r/^Game (\d+): (.+)$/, line)
      possible = draws
      |> String.split(";")
      |> Enum.all?(fn reveal ->
        red = Regex.run(~r/(\d+) red/, reveal) |> match_to_int
        green = Regex.run(~r/(\d+) green/, reveal) |> match_to_int
        blue = Regex.run(~r/(\d+) blue/, reveal) |> match_to_int
        red <= 12 && green <= 13 && blue <= 14
      end)
      if(possible, do: String.to_integer(game), else: 0)
    end)
    |> Enum.reduce(0, &+/2)
    |> IO.puts
  end

  def part2 do
    input()
    |> Enum.map(fn line ->
      [_, game, draws] = Regex.run(~r/^Game (\d+): (.+)$/, line)
      minimums = draws
      |> String.split(";")
      |> Enum.reduce([red: 0, green: 0, blue: 0], fn reveal, minimums ->
        red = Regex.run(~r/(\d+) red/, reveal) |> match_to_int
        green = Regex.run(~r/(\d+) green/, reveal) |> match_to_int
        blue = Regex.run(~r/(\d+) blue/, reveal) |> match_to_int
        [red: max(minimums[:red], red), green: max(minimums[:green], green), blue: max(minimums[:blue], blue)]
      end)
      minimums[:red] * minimums[:green] * minimums[:blue]
    end)
    |> Enum.reduce(0, &+/2)
    |> IO.puts
  end
end

Day2.part1
Day2.part2
