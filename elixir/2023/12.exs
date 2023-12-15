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
    # Input.from_string(@sample)
    Input.from_file("2023/data/12.txt")
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
    matches(pattern, regex, fast_fail)
  end

  defp matches(pattern, regex, fast_fail) do
    if !Regex.match?(fast_fail, pattern) do
      0
    else
      if String.contains?(pattern, "?") do
        matches(String.replace(pattern, "?", ".", global: false), regex, fast_fail) +
        matches(String.replace(pattern, "?", "#", global: false), regex, fast_fail)
      else
        if Regex.match?(regex, pattern), do: 1, else: 0
      end
    end
  end

  def part2 do
    input = input()
    Enum.map(input, &expand/1)
    |> Enum.map(fn line ->
      {count, _} = matches2(line, %{})
      count
    end)
    |> Enum.sum
    |> IO.puts
  end

  defp expand({pattern, groups}) do
    {repeat(pattern, 5) |> Enum.join("?"),
     repeat(groups, 5) |> Enum.concat}
  end

  defp repeat(_elem, 0), do: []
  defp repeat(elem, count), do: [elem | repeat(elem, count - 1)]

  defp matches2({"." <> pattern, groups}, cache) do
    matches2({String.trim_leading(pattern, "."), groups}, cache)
  end
  defp matches2({pattern, [group | []]}, cache) do
    if String.starts_with?(pattern, "?") do
      try_both({pattern, [group]}, cache)
    else
      if Regex.run(~r/^[?#]{#{group}}[.?]*$/, pattern) do
        {1, cache}
      else
        {0, cache}
      end
    end
  end
  defp matches2({pattern, [group | groups]}, cache) do
    cond do
      Enum.sum([group | groups]) > String.length(pattern) ->
        {0, cache}
      count = Map.get(cache, {pattern, [group | groups]}) ->
        {count, cache}
      String.starts_with?(pattern, "?") ->
        try_both({pattern, [group | groups]}, cache)
      true ->
        case Regex.run(~r/^[?#]{#{group}}[.?](.*)/, pattern) do
          [_, rest] ->
            {count, cache} = matches2({rest, groups}, cache)
            {count, Map.put(cache, {pattern, [group | groups]}, count)}
          _ ->
            {0, Map.put(cache, {pattern, [group | groups]}, 0)}
        end
    end
  end
  defp try_both({pattern, groups}, cache) do
    {c1, cache} = matches2({String.slice(pattern, 1..-1), groups}, cache)
    {c2, cache} = matches2({String.replace(pattern, "?", "#", global: false), groups}, cache)
    {c1 + c2, Map.put(cache, {pattern, groups}, c1 + c2)}
  end
end

Day12.part1
Day12.part2
