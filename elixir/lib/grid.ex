defmodule Grid do
  defstruct [:column_count, :row_count, :data]
  @type t :: %__MODULE__{
    column_count: non_neg_integer(),
    row_count: non_neg_integer(),
    data: %{{non_neg_integer(), non_neg_integer()} => any()}
  }

  def parse(lines), do: parse(lines, fn _ -> true end, &(&1))
  def parse(lines, include?), do: parse(lines, include?, &(&1))
  def parse(lines, include?, convert) do
    lines = String.trim(lines) |> String.split("\n")
    data = lines
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {row, y}, grid ->
      String.graphemes(row)
      |> Enum.with_index
      |> Enum.reduce(grid, fn {contents, x}, grid ->
        cond do
          include?.(contents) -> Map.put(grid, Point.new(x, y), convert.(contents))
          true -> grid
        end
      end)
    end)
    %Grid{
      column_count: Enum.map(lines, &String.length(&1)) |> Enum.max,
      row_count: Enum.count(lines),
      data: data
    }
  end

  def adjacent(%Grid{} = grid, %Point{} = p) do
    [
      {%Point{x: p.x - 1, y: p.y - 1}, Grid.at(grid, p.x - 1, p.y - 1)},
      {%Point{x: p.x, y: p.y - 1}, Grid.at(grid, p.x, p.y - 1)},
      {%Point{x: p.x + 1, y: p.y - 1}, Grid.at(grid, p.x + 1, p.y - 1)},
      {%Point{x: p.x - 1, y: p.y}, Grid.at(grid, p.x - 1, p.y)},
      {%Point{x: p.x + 1, y: p.y}, Grid.at(grid, p.x + 1, p.y)},
      {%Point{x: p.x - 1, y: p.y + 1}, Grid.at(grid, p.x - 1, p.y + 1)},
      {%Point{x: p.x, y: p.y + 1}, Grid.at(grid, p.x, p.y + 1)},
      {%Point{x: p.x + 1, y: p.y + 1}, Grid.at(grid, p.x + 1, p.y + 1)}
    ]
    |> Enum.filter(fn {_, contents} -> contents end)
  end
  def adjacent(%Grid{} = grid, x, y), do: adjacent(grid, %Point{x: x, y: y})

  def all(%Grid{} = grid) do
    rows(grid)
    |> Enum.reduce([], &(&2 ++ &1))
  end

  def at(%Grid{} = grid, position), do: Map.get(grid.data, position)
  def at(%Grid{} = grid, x, y), do: at(grid, %Point{x: x, y: y})

  def columns(grid) do
    Map.keys(grid.data)
    |> Enum.group_by(fn point -> point.x end)
    |> Enum.map(fn {_, column} ->
      Enum.map(column, fn point ->
        {point, at(grid, point)}
      end)
      |> Enum.sort(fn {p1, _}, {p2, _} -> p1.y <= p2.y end)
    end)
    |> Enum.sort(fn [{p1, _} | _], [{p2, _} | _] -> p1.x <= p2.x end)
  end

  def orthogonal(%Grid{} = grid, %Point{} = p) do
    [
      {%Point{x: p.x, y: p.y - 1}, Grid.at(grid, p.x, p.y - 1)},
      {%Point{x: p.x - 1, y: p.y}, Grid.at(grid, p.x - 1, p.y)},
      {%Point{x: p.x + 1, y: p.y}, Grid.at(grid, p.x + 1, p.y)},
      {%Point{x: p.x, y: p.y + 1}, Grid.at(grid, p.x, p.y + 1)}
    ]
    |> Enum.filter(fn {_, contents} -> contents end)
  end
  def orthogonal(%Grid{} = grid, x, y), do: orthogonal(grid, %Point{x: x, y: y})

  def remove(grid, %Point{} = p) do
    %Grid{grid | data: Map.delete(grid.data, p)}
  end
  def remove(grid, x, y), do: remove(grid, %Point{x: x, y: y})

  def rows(grid) do
    Map.keys(grid.data)
    |> Enum.group_by(fn point -> point.y end)
    |> Enum.map(fn {_, row} ->
      Enum.map(row, fn point ->
        {point, at(grid, point)}
      end)
      |> Enum.sort(fn {p1, _}, {p2, _} -> p1.x <= p2.x end)
    end)
    |> Enum.sort(fn [{p1, _} | _], [{p2, _} | _] -> p1.y <= p2.y end)
  end

  def to_string(grid) do
    rows(grid)
    |> Enum.map(fn row ->
      Enum.map(row, fn {_position, contents} -> contents end)
      |> Enum.join
    end)
    |> Enum.join("\n")
  end

  def update(grid, %Point{} = p, contents) do
    %Grid{grid | data: Map.put(grid.data, p, contents)}
  end
end
