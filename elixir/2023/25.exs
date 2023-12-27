defmodule Day25 do
  @sample """
  jqt: rhn xhk nvd
  rsh: frs pzl lsr
  xhk: hfx
  cmg: qnr nvd lhk bvb
  rhn: xhk bvb hfx
  bvb: xhk hfx
  pzl: lsr hfx nvd
  qnr: nvd
  ntq: jqt hfx bvb xhk
  nvd: lhk
  lsr: lhk
  rzs: qnr cmg lsr rsh
  frs: qnr lhk lsr
  """

  defp input do
    # Input.from_string(@sample)
    Input.from_file("2023/data/25.txt")
    |> Enum.reduce(%{}, fn line, map ->
      [lhs, rhs] = String.split(line, ": ")
      String.split(rhs, " ")
      |> Enum.reduce(map, fn component, map ->
        connect(map, lhs, component)
      end)
    end)
  end

  defp connect(map, a, b) do
    set = Map.get(map, a, MapSet.new)
    |> MapSet.put(b)
    map = Map.put(map, a, set)
    set = Map.get(map, b, MapSet.new)
    |> MapSet.put(a)
    Map.put(map, b, set)
  end

  def part1 do
    graph = input()
    edges = all_edges(graph)
    |> MapSet.to_list
    find_groups(edges -- [["mtc", "rhh"], ["gpj", "tmb"], ["njn", "xtx"]])
    |> Enum.map(&Enum.count/1)
    |> Enum.product
    |> IO.puts
  end

  defp all_edges(graph) do
    Enum.reduce(graph, MapSet.new, fn {node, connections}, edges ->
      Enum.reduce(connections, edges, fn connection, edges ->
        MapSet.put(edges, Enum.sort([node, connection]))
      end)
    end)
  end

  defp find_groups(edges, groups \\ [])
  defp find_groups([], groups), do: groups
  defp find_groups([edge | edges], groups) do
    groups = add_to_group(edge, groups)
    |> merge_groups
    find_groups(edges, groups)
  end

  defp add_to_group(edge, []), do: [MapSet.new(edge)]
  defp add_to_group(edge, [group | groups]) do
    edge = MapSet.new(edge)
    if MapSet.size(MapSet.intersection(group, edge)) > 0 do
      [MapSet.union(group, edge) | groups]
    else
      [group | add_to_group(edge, groups)]
    end
  end

  defp merge_groups([]), do: []
  defp merge_groups([group | groups]) do
    merged = merge_groups(groups)
    |> Enum.map(fn other ->
      if MapSet.disjoint?(group, other) do
        {false, other}
      else
        {true, MapSet.union(other, group)}
      end
    end)
    if Enum.any?(merged, fn {was_merged, _} -> was_merged end) do
      Enum.map(merged, fn {_, other} -> other end)
    else
      [group | Enum.map(merged, fn {_, other} -> other end)]
    end
  end
end

Day25.part1
