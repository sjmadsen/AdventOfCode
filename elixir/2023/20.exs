defmodule Day20 do
  @sample """
  broadcaster -> a, b, c
  %a -> b
  %b -> c
  %c -> inv
  &inv -> a
  """

  @sample2 """
  broadcaster -> a
  %a -> inv, con
  &inv -> b
  %b -> con
  &con -> output
  """

  defp input do
    # Input.from_string(@sample2)
    Input.from_file("2023/data/20.txt")
    |> Enum.reduce(%{}, fn line, map ->
      [module, outputs] = String.split(line, " -> ")
      outputs = String.split(outputs, ", ")
      {map, name} = define_module(map, module)
      connect_modules(map, name, outputs)
    end)
  end

  defp define_module(map, "broadcaster") do
    {Map.put(map, "broadcaster", %{name: "broadcaster", type: :broadcaster, outputs: []}), "broadcaster"}
  end
  defp define_module(map, "%" <> name) do
    module = Map.get(map, name, %{})
    |> Map.put(:name, name)
    |> Map.put(:type, :flipflop)
    |> Map.put(:state, false)
    {Map.put(map, name, module), name}
  end
  defp define_module(map, "&" <> name) do
    module = Map.get(map, name, %{})
    |> Map.put(:name, name)
    |> Map.put(:type, :conjunction)
    memory = Enum.reduce(Map.get(module, :inputs, []), %{}, fn input, memory ->
      Map.put(memory, input, :low)
    end)
    module = Map.put(module, :memory, memory)
    {Map.put(map, name, module), name}
  end

  defp connect_modules(map, _name, []), do: map
  defp connect_modules(map, name, [output_name | rest]) do
    module = Map.get(map, name, %{name: name, outputs: []})
    |> Map.update(:outputs, [output_name], &(&1 ++ [output_name]))
    output = Map.get(map, output_name, %{name: output_name})
    |> Map.update(:inputs, [name], &(&1 ++ [name]))
    output = case Map.get(output, :type, :unknown) do
      :conjunction ->
        Map.update(output, :memory, %{}, &(Map.put(&1, name, :low)))
      _ ->
        output
    end
    Map.put(map, name, module)
    |> Map.put(output_name, output)
    |> connect_modules(name, rest)
  end

  def part1 do
    circuit = input()
    {_, counts} = repeat({circuit, %{low: 0, high: 0}}, [{"button", "broadcaster", :low}], 0, 1000)
    Map.values(counts)
    |> Enum.product
    |> IO.puts
  end

  defp count_pulses(circuit, [], counts), do: {circuit, counts}
  defp count_pulses(circuit, [{sender, receiver, pulse} | pending], counts) do
    counts = Map.update!(counts, pulse, &(&1 + 1))
    propagate(circuit, sender, Map.get(circuit, receiver), pulse, pending, counts)
  end

  defp propagate(circuit, _sender, %{type: :broadcaster} = receiver, pulse, pending, counts) do
    send_pulse(circuit, receiver, pulse, pending, counts)
  end
  defp propagate(circuit, _sender, %{name: name}, :low, pending, counts) when name in ["hh", "fh", "lk", "fn"] do
    count_pulses(circuit, pending, Map.update(counts, :rx, 1, &(&1 + 1)))
  end
  defp propagate(circuit, _sender, %{type: :flipflop}, :high, pending, counts), do: count_pulses(circuit, pending, counts)
  defp propagate(circuit, _sender, %{type: :flipflop} = receiver, :low, pending, counts) do
    receiver = Map.update!(receiver, :state, &(!&1))
    circuit = Map.put(circuit, receiver.name, receiver)
    new_pulse = if receiver.state, do: :high, else: :low
    send_pulse(circuit, receiver, new_pulse, pending, counts)
  end
  defp propagate(circuit, sender, %{type: :conjunction} = receiver, pulse, pending, counts) do
    memory = Map.put(receiver.memory, sender, pulse)
    circuit = Map.put(circuit, receiver.name, %{receiver | memory: memory})
    new_pulse = if Enum.all?(Map.values(memory), &(&1 == :high)), do: :low, else: :high
    send_pulse(circuit, receiver, new_pulse, pending, counts)
  end
  defp propagate(circuit, _sender, _receiver, _pulse, pending, counts), do: count_pulses(circuit, pending, counts)

  defp send_pulse(circuit, module, pulse, pending, counts) do
    pending = pending ++ Enum.zip([Stream.cycle([module.name]), module.outputs, Stream.cycle([pulse])])
    count_pulses(circuit, pending, counts)
  end

  def part2 do
    circuit = input()
    ["rz", "kv", "fd", "fp"]
    |> Enum.map(fn node ->
      repeat({circuit, %{low: 0, high: 0}}, [{"broadcaster", node, :low}], 0, nil)
    end)
    |> Enum.reduce(&lcm/2)
    |> IO.puts
  end

  defp repeat(result, _, stop, stop), do: result
  defp repeat({_, %{rx: 1}}, _, n, _stop), do: n
  defp repeat({circuit, counts}, initial, n, stop) do
    repeat(count_pulses(circuit, initial, counts), initial, n + 1, stop)
  end

  defp lcm(a, b) do
    {gcd, _, _} = Integer.extended_gcd(a, b)
    a * div(b, gcd)
  end
end

Day20.part1
Day20.part2
