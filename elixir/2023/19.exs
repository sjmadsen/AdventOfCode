defmodule Day19 do
  @sample """
  px{a<2006:qkq,m>2090:A,rfg}
  pv{a>1716:R,A}
  lnx{m>1548:A,A}
  rfg{s<537:gd,x>2440:R,A}
  qs{s>3448:A,lnx}
  qkq{x<1416:A,crn}
  crn{x>2662:A,R}
  in{s<1351:px,qqz}
  qqz{s>2770:qs,m<1801:hdj,R}
  gd{a>3333:R,R}
  hdj{m>838:A,pv}

  {x=787,m=2655,a=1222,s=2876}
  {x=1679,m=44,a=2067,s=496}
  {x=2036,m=264,a=79,s=2244}
  {x=2461,m=1339,a=466,s=291}
  {x=2127,m=1623,a=2188,s=1013}
  """

  defp input do
    {:ok, lines} = File.read("2023/data/19.txt")
    [workflows, parts] =
    # @sample
    lines
    |> String.trim
    |> String.split("\n\n")
    workflows = String.split(workflows, "\n")
    |> Enum.map(&parse_workflow/1)
    |> Enum.reduce(%{}, fn workflow, map -> Map.put(map, workflow.name, workflow) end)
    {
      workflows,
      String.split(parts, "\n") |> Enum.map(&parse_part/1)
    }
  end

  defp parse_workflow(line) do
    [_, name, steps] = Regex.run(~r/^(.*)\{(.*)\}$/, line)
    steps = String.split(steps, ",")
    |> Enum.map(fn step ->
      case Regex.run(~r/^(.)(.)(\d+):(.*)$/, step) do
        [_, attribute, operation, value, destination] ->
          %{attribute: attribute, operation: operation, value: String.to_integer(value), destination: destination}
        nil ->
          %{destination: step}
      end
    end)
    %{name: name, steps: steps}
  end

  defp parse_part(line) do
    String.slice(line, 1..-2)
    |> String.split(",")
    |> Enum.reduce(%{}, fn attribute, part ->
      [name, value] = String.split(attribute, "=")
      Map.put(part, name, String.to_integer(value))
    end)
  end

  def part1 do
    {workflows, parts} = input()
    parts
    |> Enum.filter(&(run_workflow(workflows, "in", &1) == :accepted))
    |> Enum.map(&(Map.values(&1) |> Enum.sum))
    |> Enum.sum
    |> IO.puts
  end

  defp run_workflow(_workflows, "A", _part), do: :accepted
  defp run_workflow(_workflows, "R", _part), do: :rejected
  defp run_workflow(workflows, name, part) do
    workflow = Map.get(workflows, name)
    run_step(workflows, workflow.steps, part)
  end

  defp run_step(workflows, [%{attribute: attribute, operation: "<", value: value, destination: destination} | steps], part) do
    if Map.get(part, attribute) < value do
      run_workflow(workflows, destination, part)
    else
      run_step(workflows, steps, part)
    end
  end
  defp run_step(workflows, [%{attribute: attribute, operation: ">", value: value, destination: destination} | steps], part) do
    if Map.get(part, attribute) > value do
      run_workflow(workflows, destination, part)
    else
      run_step(workflows, steps, part)
    end
  end
  defp run_step(workflows, [%{destination: destination} | _], part) do
    run_workflow(workflows, destination, part)
  end

  def part2 do
    {workflows, _} = input()
    accepted_ranges(workflows, "in")
    |> IO.puts
  end

  defp accepted_ranges(workflows, name) do
    narrow(%{"x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000}, workflows, name)
  end

  defp narrow(ranges, _, "A") do
    Map.values(ranges)
    |> Enum.map(&(Range.size(&1)))
    |> Enum.product
  end
  defp narrow(ranges, _, "R"), do: 0
  defp narrow(ranges, workflows, %{} = workflow) do
    narrow_step(ranges, workflows, workflow.steps)
  end
  defp narrow(ranges, workflows, destination), do: narrow(ranges, workflows, Map.get(workflows, destination))

  defp narrow_step(ranges, workflows, [%{attribute: attribute, operation: "<", value: value, destination: destination} | steps]) do
    pass_range = RangeEx.intersection(Map.get(ranges, attribute), 1..(value - 1))
    fail_range = RangeEx.intersection(Map.get(ranges, attribute), value..4000)
    narrow(%{ranges | attribute => pass_range}, workflows, destination) +
    narrow_step(%{ranges | attribute => fail_range}, workflows, steps)
  end
  defp narrow_step(ranges, workflows, [%{attribute: attribute, operation: ">", value: value, destination: destination} | steps]) do
    pass_range = RangeEx.intersection(Map.get(ranges, attribute), (value + 1)..4000)
    fail_range = RangeEx.intersection(Map.get(ranges, attribute), 1..value)
    narrow(%{ranges | attribute => pass_range}, workflows, destination) +
    narrow_step(%{ranges | attribute => fail_range}, workflows, steps)
  end
  defp narrow_step(ranges, workflows, [%{destination: destination} | _]) do
    narrow(ranges, workflows, destination)
  end
end

Day19.part1
Day19.part2
