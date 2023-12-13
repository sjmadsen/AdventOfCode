defmodule Grid do
  defstruct [:column_count, :row_count, :data]
  @type t :: %__MODULE__{
    column_count: non_neg_integer(),
    row_count: non_neg_integer(),
    data: %{{non_neg_integer(), non_neg_integer()} => any()}
  }

  def parse(lines), do: parse(lines, fn _ -> true end)
  def parse(lines, fun) do
    lines = String.trim(lines) |> String.split("\n")
    data = lines
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {row, row_index}, grid ->
      String.graphemes(row)
      |> Enum.with_index
      |> Enum.reduce(grid, fn {contents, col_index}, grid ->
        cond do
          fun.(contents) -> Map.put(grid, {col_index, row_index}, contents)
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

  def adjacent(%Grid{} = grid, {column, row}), do: adjacent(grid, column, row)
  @spec adjacent(Grid.t(), number(), number()) :: list()
  def adjacent(%Grid{} = grid, column, row) do
    [
      {column - 1, row - 1, Grid.at(grid, column - 1, row - 1)},
      {column, row - 1, Grid.at(grid, column, row - 1)},
      {column + 1, row - 1, Grid.at(grid, column + 1, row - 1)},
      {column - 1, row, Grid.at(grid, column - 1, row)},
      {column + 1, row, Grid.at(grid, column + 1, row)},
      {column - 1, row + 1, Grid.at(grid, column - 1, row + 1)},
      {column, row + 1, Grid.at(grid, column, row + 1)},
      {column + 1, row + 1, Grid.at(grid, column + 1, row + 1)}
    ]
    |> Enum.filter(fn {_, _, contents} -> contents end)
  end

  def all(%Grid{} = grid) do
    rows(grid)
    |> Enum.reduce([], &(&2 ++ &1))
  end

  def at(%Grid{} = grid, position), do: Map.get(grid.data, position)
  def at(%Grid{} = grid, column, row), do: at(grid, {column, row})

  def columns(grid) do
    Map.keys(grid.data)
    |> Enum.group_by(fn {column, _} -> column end)
    |> Enum.map(fn {_, column} ->
      Enum.map(column, fn position ->
        {position, at(grid, position)}
      end)
      |> Enum.sort(fn {{_, row1}, _}, {{_, row2}, _} -> row1 <= row2 end)
    end)
  end

  def orthogonal(%Grid{} = grid, {column, row}), do: orthogonal(grid, column, row)
  def orthogonal(%Grid{} = grid, column, row) do
    [
      {column, row - 1, Grid.at(grid, column, row - 1)},
      {column - 1, row, Grid.at(grid, column - 1, row)},
      {column + 1, row, Grid.at(grid, column + 1, row)},
      {column, row + 1, Grid.at(grid, column, row + 1)}
    ]
    |> Enum.filter(fn {_, _, contents} -> contents end)
  end

  def rows(grid) do
    Map.keys(grid.data)
    |> Enum.group_by(fn {_, row} -> row end)
    |> Enum.map(fn {_, row} ->
      Enum.map(row, fn position ->
        {position, at(grid, position)}
      end)
      |> Enum.sort(fn {{col1, _}, _}, {{col2, _}, _} -> col1 <= col2 end)
    end)
  end

  def update(grid, position, contents) do
    data = Map.put(grid.data, position, contents)
    %Grid{grid | data: data}
  end
end
