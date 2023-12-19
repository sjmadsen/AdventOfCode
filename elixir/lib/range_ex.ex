defmodule RangeEx do
  def intersection([%Range{} = range | []]), do: [range]
  def intersection([%Range{} = range | ranges]) do
    start_size = Enum.count(ranges) + 1
    reduced = Enum.reduce(ranges, [range], fn range, into ->
      Enum.map(into, fn reduced -> intersection(range, reduced) end)
      |> Enum.uniq
    end)
    |> Enum.sort(fn r1, r2 -> r1.first < r2.first end)

    if Enum.count(reduced) < start_size, do: intersection(reduced), else: reduced
  end

  def intersection(%Range{} = r1, %Range{} = r2) when r1.last > r2.first and r1.first > r2.last, do: 0..-1//1
  def intersection(%Range{} = r1, %Range{} = r2) when r2.last > r1.first and r2.first > r1.last, do: 0..-1//1
  def intersection(%Range{} = r1, %Range{} = r2) do
    max(r1.first, r2.first)..min(r1.last, r2.last)//1
  end

  def union([%Range{} = range | []]) do
    [range]
  end
  def union([%Range{} = range | ranges]) do
    start_size = Enum.count(ranges) + 1
    combined = Enum.reduce(ranges, [range], fn range, into ->
      Enum.flat_map(into, fn combined -> union(range, combined) end)
      |> Enum.uniq
    end)
    |> Enum.sort(fn r1, r2 -> r1.first < r2.first end)

    if Enum.count(combined) < start_size, do: union(combined), else: combined
  end

  defp union(%Range{} = r1, %Range{} = r2) when r2.first < r1.first, do: union(r2, r1)
  defp union(%Range{} = r1, %Range{} = r2) when abs(r1.last - r2.first) == 1 or abs(r1.first - r2.last) == 1 do
    [min(r1.first, r2.first)..max(r1.last, r2.last)]
  end
  defp union(%Range{} = r1, %Range{} = r2) when r2.first >= r1.first and r2.last <= r1.last do
    [r1]
  end
  defp union(%Range{} = r1, %Range{} = r2) do
    [r1, r2]
  end
end
