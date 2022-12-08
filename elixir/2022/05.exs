defmodule Day5 do
  def parse_initial_stacks(stacks) do
    Enum.drop(stacks, -1)
    |> parse_lines()
  end

  defp parse_lines(input, stacks \\ [])
  defp parse_lines([], stacks), do: stacks
  defp parse_lines([line | rest], stacks) do
    parse_lines(rest, stacks)
    |> build_stacks(line)
  end

  defp build_stacks(stacks, ""), do: stacks
  defp build_stacks([], line), do: build_stacks([[]], line)
  defp build_stacks([this_stack | rest], line) do
    rest = build_stacks(rest, String.slice(line, 4..-1))
    [extract_crate(this_stack, String.at(line, 1)) | rest]
  end

  defp extract_crate(stack, " "), do: stack
  defp extract_crate(stack, crate), do: [crate | stack]

  def parse_instruction(line) do
    [_, move, from, to] = Regex.split(~r{\D+}, line)
    {String.to_integer(move), String.to_integer(from) - 1, String.to_integer(to) - 1}
  end

  def part1(stacks, []), do: stacks
  def part1(stacks, [instruction | rest]) do
    stacks
    |> move_single(parse_instruction(instruction))
    |> part1(rest)
  end

  defp move_single(stacks, {0, _, _}), do: stacks
  defp move_single(stacks, {move, from, to}) do
    crate = hd(Enum.at(stacks, from))
    stacks
    |> List.update_at(from, &(tl(&1)))
    |> List.update_at(to, &([crate | &1]))
    |> move_single({move - 1, from, to})
  end

  def part2(stacks, []), do: stacks
  def part2(stacks, [instruction | rest]) do
    stacks
    |> move_group(parse_instruction(instruction))
    |> part2(rest)
  end

  defp move_group(stacks, {move, from, to}) do
    {old_stack, crates} = pop_n(Enum.at(stacks, from), [], move)
    stacks
    |> List.update_at(from, fn _ -> old_stack end)
    |> List.update_at(to, &(crates ++ &1))
  end

  defp pop_n(list, acc, 0), do: {list, acc}
  defp pop_n([elem | rest], acc, n) do
    pop_n(rest, acc ++ [elem], n - 1)
  end

  def top_of_stack([]), do: ""
  def top_of_stack([stack | rest]) do
    hd(stack) <> top_of_stack(rest)
  end
end

{stacks, instructions} = File.stream!("2022/data/5.input")
|> Enum.map(&String.trim_trailing/1)
|> Enum.split_while(&(&1 != ""))

stacks = Day5.parse_initial_stacks(stacks)
instructions = tl(instructions)

Day5.part1(stacks, instructions)
|> Day5.top_of_stack
|> IO.puts

Day5.part2(stacks, instructions)
|> Day5.top_of_stack
|> IO.puts
