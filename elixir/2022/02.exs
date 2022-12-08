defmodule Day2 do
  @part1_result %{
    "A X" => 4, "A Y" => 8, "A Z" => 3,
    "B X" => 1, "B Y" => 5, "B Z" => 9,
    "C X" => 7, "C Y" => 2, "C Z" => 6
  }

  def part1(line) do
    @part1_result[String.trim(line)]
  end

  @part2_result %{
    "A X" => 3, "A Y" => 4, "A Z" => 8,
    "B X" => 1, "B Y" => 5, "B Z" => 9,
    "C X" => 2, "C Y" => 6, "C Z" => 7
  }

  def part2(line) do
    @part2_result[String.trim(line)]
  end
end

File.stream!("2022/data/2.input")
|> Enum.map(&Day2.part2/1)
|> Enum.reduce(0, &+/2)
|> IO.puts()
