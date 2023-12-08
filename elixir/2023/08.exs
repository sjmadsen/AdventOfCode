defmodule Day8 do
  @sample1 """
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  """

  @sample2 """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  @sample3 """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """

  defp input do
    {:ok, lines} = File.read("2023/data/08.txt")
    [instructions, nodes] = lines
    |> String.trim
    |> String.split("\n\n")
    network = nodes
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, nodes ->
      [_, node, left, right] = Regex.run(~r/(\w+) = \((\w+), (\w+)\)/, line)
      Map.put(nodes, node, {left, right})
    end)
    {instructions, network}
  end

  def part1 do
    {instructions, network} = input()
    steps = Stream.cycle(String.graphemes(instructions))
    |> Stream.scan("AAA", fn direction, node ->
      {left, right} = Map.get(network, node)
      case direction do
        "L" -> left
        "R" -> right
      end
    end)
    |> Enum.reduce_while(1, fn node, step ->
      if node == "ZZZ" do
        {:halt, step}
      else
        {:cont, step + 1}
      end
    end)
    |> IO.puts
  end

  def part2 do
    {instructions, network} = input()
    cycles = Map.keys(network)
    |> Enum.filter(&(String.ends_with?(&1, "A")))
    |> IO.inspect
    |> Stream.map(fn node ->
      Stream.cycle(String.graphemes(instructions))
      |> Stream.scan(node, fn direction, node ->
        {left, right} = Map.get(network, node)
        case direction do
          "L" -> left
          "R" -> right
        end
      end)
      |> Enum.reduce_while(1, fn node, step ->
        if String.ends_with?(node, "Z") do
          {:halt, step}
        else
          {:cont, step + 1}
        end
      end)
    end)
    |> Enum.to_list
    |> IO.inspect
    gcd = Enum.reduce(cycles, &gcd/2)
    Enum.reduce(cycles, &lcm/2)
    |> IO.puts
  end

  defp gcd(a, b) when a == b, do: a
  defp gcd(a, b) do
    if a > b do
      gcd(a - b, b)
    else
      gcd(a, b - a)
    end
  end

  defp lcm(a, b) do
    a * (b / gcd(a, b))
  end
end

Day8.part1
Day8.part2
