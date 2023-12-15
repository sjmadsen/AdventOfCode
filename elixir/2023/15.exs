defmodule Day15 do
  @sample "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

  defp input() do
    # @sample
    {:ok, line} = File.read("2023/data/15.txt")
    line
    |> String.trim
    |> String.split(",")
  end

  def part1 do
    input()
    |> Enum.map(&hash/1)
    |> Enum.sum
    |> IO.puts
  end

  defp hash(string) do
    to_charlist(string)
    |> Enum.reduce(0, fn char, hash ->
      rem((hash + char) * 17, 256)
    end)
  end

  def part2 do
    input()
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, &process/2)
    |> focusing_power
    |> IO.puts
  end

  defp parse(operation) do
    cond do
      String.ends_with?(operation, "-") ->
        {String.slice(operation, 0..-2), "-"}
      String.contains?(operation, "=") ->
        [label, lens] = String.split(operation, "=")
        {label, "=", String.to_integer(lens)}
      true ->
        {}
    end
  end

  defp process({label, "-"}, boxes) do
    box = hash(label)
    lenses = Map.get(boxes, box, [])
    |> Enum.reject(fn {label2, _} -> label == label2 end)
    Map.put(boxes, box, lenses)
  end
  defp process({label, "=", lens}, boxes) do
    box = hash(label)
    lenses = Map.get(boxes, box, [])
    case Enum.find(lenses, fn {label2, _} -> label == label2 end) do
      nil ->
        Map.put(boxes, box, lenses ++ [{label, lens}])
      _ ->
        lenses = Enum.map(lenses, fn {label2, _} = existing ->
          if label == label2 do
            {label, lens}
          else
            existing
          end
        end)
        Map.put(boxes, box, lenses)
    end
  end

  defp focusing_power(boxes) do
    Enum.map(boxes, fn {box, lenses} ->
      Enum.with_index(lenses)
      |> Enum.map(fn {{_, lens}, slot} ->
        (box + 1) * (slot + 1) * lens
      end)
      |> Enum.sum
    end)
    |> Enum.sum
  end
end

Day15.part1
Day15.part2
