defmodule GridTests do
  use ExUnit.Case, async: true

  @input """
  .....
  +.*..
  .!.--
  1234.
  """

  test "parse/1" do
    input = """
    .x.
    o.o
    """

    assert Grid.parse(input) == %Grid{
      column_count: 3, row_count: 2,
      data: %{
        {0,0} => ".", {1,0} => "x", {2,0} => ".",
        {0,1} => "o", {1,1} => ".", {2,1} => "o"
      }
    }

    assert Grid.parse(input, &(&1 != ".")) == %Grid{
      column_count: 3, row_count: 2,
      data: %{
        {1,0} => "x", {0,1} => "o", {2,1} => "o"
      }
    }
  end

  test "adjacent/2" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.adjacent(grid, {1, 2}) == [{0, 1, "+"}, {2, 1, "*"}, {0, 3, "1"}, {1, 3, "2"}, {2, 3, "3"}]
    assert Grid.adjacent(grid, {1, 3}) == [{1, 2, "!"}, {0, 3, "1"}, {2, 3, "3"}]
    assert Grid.adjacent(grid, {4, 0}) == []
  end

  test "adjacent/3" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.adjacent(grid, 1, 2) == [{0, 1, "+"}, {2, 1, "*"}, {0, 3, "1"}, {1, 3, "2"}, {2, 3, "3"}]
    assert Grid.adjacent(grid, 1, 3) == [{1, 2, "!"}, {0, 3, "1"}, {2, 3, "3"}]
    assert Grid.adjacent(grid, 4, 0) == []
  end

  test "all/1" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.all(grid) == [
      {{0, 1}, "+"}, {{2, 1}, "*"}, {{1, 2}, "!"}, {{3, 2}, "-"}, {{4, 2}, "-"}, {{0, 3}, "1"}, {{1, 3}, "2"}, {{2, 3}, "3"}, {{3, 3}, "4"}
    ]
  end

  test "at/2" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.at(grid, {0,1}) == "+"
    assert Grid.at(grid, {0,0}) == nil
    assert Grid.at(grid, {-1,10}) == nil
  end

  test "at/3" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.at(grid, 0, 1) == "+"
    assert Grid.at(grid, 0, 0) == nil
    assert Grid.at(grid, -1, 10) == nil
  end

  test "orthogonal/2" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.orthogonal(grid, {1, 2}) == [{1, 3, "2"}]
    assert Grid.orthogonal(grid, {1, 3}) == [{1, 2, "!"}, {0, 3, "1"}, {2, 3, "3"}]
    assert Grid.orthogonal(grid, {1, 0}) == []
  end

  test "orthogonal/3" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.orthogonal(grid, 1, 2) == [{1, 3, "2"}]
    assert Grid.orthogonal(grid, 1, 3) == [{1, 2, "!"}, {0, 3, "1"}, {2, 3, "3"}]
    assert Grid.orthogonal(grid, 1, 0) == []
  end

  test "rows/1" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.rows(grid) == [
      [{{0, 1}, "+"}, {{2, 1}, "*"}],
      [{{1, 2}, "!"}, {{3, 2}, "-"}, {{4, 2}, "-"}],
      [{{0, 3}, "1"}, {{1, 3}, "2"}, {{2, 3}, "3"}, {{3, 3}, "4"}]
    ]
  end
end
