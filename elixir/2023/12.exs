defmodule Day12 do
  @sample """
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
  """

  defp input do
    Input.from_string(@sample)
    # Input.from_file("2023/data/12.txt")
    |> Enum.map(fn line ->
      [pattern, groups] = String.split(line, " ")
      groups = String.split(groups, ",")
      |> Enum.map(&(String.to_integer(&1)))
      {pattern, groups}
    end)
  end

  def part1 do
    input()
    |> Enum.map(&matches/1)
    |> Enum.sum
    |> IO.puts
  end

  defp matches({pattern, groups}) do
    regex = Enum.map(groups, fn repeats -> "#\{#{repeats}}" end)
    |> Enum.join("\\.+")
    regex = Regex.compile!("^\\.*#{regex}\\.*$")
    fast_fail = Enum.map(groups, fn repeats -> "[?#]\{#{repeats}}" end)
    |> Enum.join("\[?.]+")
    fast_fail = Regex.compile!("^[?.]*#{fast_fail}[?.]*$")
    # |> IO.inspect
    matches(pattern, regex, fast_fail)
  end

  defp matches(pattern, regex, fast_fail) do
    if !Regex.match?(fast_fail, pattern) do
      # IO.inspect([pattern, fast_fail], label: "stop recursion")
      0
    else
      if String.contains?(pattern, "?") do
        matches(String.replace(pattern, "?", ".", global: false), regex, fast_fail) +
        matches(String.replace(pattern, "?", "#", global: false), regex, fast_fail)
      else
        if Regex.match?(regex, pattern) do
          # IO.inspect([pattern, regex], label: "match")
          1
        else
          0
        end
      end
    end
  end
end

Day12.part1
