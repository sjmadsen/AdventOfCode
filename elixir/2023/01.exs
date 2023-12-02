# lines = """
# 1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet
# """

{:ok, lines} = File.read("2023/data/01.txt")
lines
|> String.trim
|> String.split("\n")
|> Enum.map(fn line ->
  first = Regex.run(~r/(\d)/, line) |> List.last
  last = Regex.run(~r/(\d)\D*$/, line) |> List.last
  String.to_integer(first <> last)
end)
|> Enum.reduce(0, &+/2)
|> IO.puts

defmodule Day1 do
  def replace_spellings(line) do
    spellings = %{"one" => "o1e", "two" => "t2o", "three" => "t3e", "four" => "f4r", "five" => "f5e", "six" => "s6x", "seven" => "s7n", "eight" => "e8t", "nine" => "n9e"}
    re = ~r/(one|two|three|four|five|six|seven|eight|nine)/
    if Regex.match?(re, line) do
      Regex.replace(re, line, fn _, match ->
        spellings[match]
      end, global: false)
      |> replace_spellings
    else
      line
    end
  end
end

# lines = """
# two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen
# """

lines
|> String.trim
|> String.split("\n")
|> Enum.map(fn line ->
  line = Day1.replace_spellings(line)
  first = Regex.run(~r/(\d)/, line) |> List.last
  last = Regex.run(~r/(\d)\D*$/, line) |> List.last
  String.to_integer(first <> last)
end)
|> Enum.reduce(0, &+/2)
|> IO.puts
