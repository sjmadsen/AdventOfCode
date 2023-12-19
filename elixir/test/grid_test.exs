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
        %Point{x: 0, y: 0} => ".", %Point{x: 1, y: 0} => "x", %Point{x: 2, y: 0} => ".",
        %Point{x: 0, y: 1} => "o", %Point{x: 1, y: 1} => ".", %Point{x: 2, y: 1} => "o"
      }
    }
  end

  test "parse/3" do
    input = """
    .x.
    o.o
    """

    assert Grid.parse(input, &(&1 != ".")) == %Grid{
      column_count: 3, row_count: 2,
      data: %{
        %Point{x: 1, y: 0} => "x", %Point{x: 0, y: 1} => "o", %Point{x: 2, y: 1} => "o"
      }
    }

    assert Grid.parse(input, &(&1 != "."), &(&1 == "o")) == %Grid{
      column_count: 3, row_count: 2,
      data: %{
        %Point{x: 1, y: 0} => false, %Point{x: 0, y: 1} => true, %Point{x: 2, y: 1} => true
      }
    }
  end

  test "adjacent/2" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.adjacent(grid, %Point{x: 1, y: 2}) == [{%Point{x: 0, y: 1}, "+"}, {%Point{x: 2, y: 1}, "*"}, {%Point{x: 0, y: 3}, "1"}, {%Point{x: 1, y: 3}, "2"}, {%Point{x: 2, y: 3}, "3"}]
    assert Grid.adjacent(grid, %Point{x: 1, y: 3}) == [{%Point{x: 1, y: 2}, "!"}, {%Point{x: 0, y: 3}, "1"}, {%Point{x: 2, y: 3}, "3"}]
    assert Grid.adjacent(grid, %Point{x: 4, y: 0}) == []
  end

  test "adjacent/3" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.adjacent(grid, 1, 2) == [{%Point{x: 0, y: 1}, "+"}, {%Point{x: 2, y: 1}, "*"}, {%Point{x: 0, y: 3}, "1"}, {%Point{x: 1, y: 3}, "2"}, {%Point{x: 2, y: 3}, "3"}]
    assert Grid.adjacent(grid, 1, 3) == [{%Point{x: 1, y: 2}, "!"}, {%Point{x: 0, y: 3}, "1"}, {%Point{x: 2, y: 3}, "3"}]
    assert Grid.adjacent(grid, 4, 0) == []
  end

  test "all/1" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.all(grid) == [
      {%Point{x: 0, y: 1}, "+"}, {%Point{x: 2, y: 1}, "*"}, {%Point{x: 1, y: 2}, "!"}, {%Point{x: 3, y: 2}, "-"}, {%Point{x: 4, y: 2}, "-"}, {%Point{x: 0, y: 3}, "1"}, {%Point{x: 1, y: 3}, "2"}, {%Point{x: 2, y: 3}, "3"}, {%Point{x: 3, y: 3}, "4"}
    ]
  end

  test "at/2" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.at(grid, %Point{x: 0, y: 1}) == "+"
    assert Grid.at(grid, %Point{x: 0, y: 0}) == nil
    assert Grid.at(grid, %Point{x: -1, y: 10}) == nil
  end

  test "at/3" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.at(grid, 0, 1) == "+"
    assert Grid.at(grid, 0, 0) == nil
    assert Grid.at(grid, -1, 10) == nil
  end

  test "columns/1" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.columns(grid) == [
      [{%Point{x: 0, y: 1}, "+"}, {%Point{x: 0, y: 3}, "1"}],
      [{%Point{x: 1, y: 2}, "!"}, {%Point{x: 1, y: 3}, "2"}],
      [{%Point{x: 2, y: 1}, "*"}, {%Point{x: 2, y: 3}, "3"}],
      [{%Point{x: 3, y: 2}, "-"}, {%Point{x: 3, y: 3}, "4"}],
      [{%Point{x: 4, y: 2}, "-"}]
    ]
  end

  test "orthogonal/2" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.orthogonal(grid, %Point{x: 1, y: 2}) == [{%Point{x: 1, y: 3}, "2"}]
    assert Grid.orthogonal(grid, %Point{x: 1, y: 3}) == [{%Point{x: 1, y: 2}, "!"}, {%Point{x: 0, y: 3}, "1"}, {%Point{x: 2, y: 3}, "3"}]
    assert Grid.orthogonal(grid, %Point{x: 1, y: 0}) == []
  end

  test "orthogonal/3" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.orthogonal(grid, 1, 2) == [{%Point{x: 1, y: 3}, "2"}]
    assert Grid.orthogonal(grid, 1, 3) == [{%Point{x: 1, y: 2}, "!"}, {%Point{x: 0, y: 3}, "1"}, {%Point{x: 2, y: 3}, "3"}]
    assert Grid.orthogonal(grid, 1, 0) == []
  end

  test "remove/2" do
    grid = Grid.parse(@input, &(&1 != "."))
    grid = Grid.remove(grid, %Point{x: 0, y: 1})
    assert Grid.at(grid, %Point{x: 0, y: 1}) == nil
  end

  test "remove/3" do
    grid = Grid.parse(@input, &(&1 != "."))
    grid = Grid.remove(grid, 0, 1)
    assert Grid.at(grid, %Point{x: 0, y: 1}) == nil
  end

  test "rows/1" do
    grid = Grid.parse(@input, &(&1 != "."))
    assert Grid.rows(grid) == [
      [{%Point{x: 0, y: 1}, "+"}, {%Point{x: 2, y: 1}, "*"}],
      [{%Point{x: 1, y: 2}, "!"}, {%Point{x: 3, y: 2}, "-"}, {%Point{x: 4, y: 2}, "-"}],
      [{%Point{x: 0, y: 3}, "1"}, {%Point{x: 1, y: 3}, "2"}, {%Point{x: 2, y: 3}, "3"}, {%Point{x: 3, y: 3}, "4"}]
    ]
  end

  test "update/3" do
    grid = Grid.parse(".x.\no.o\n!!!")
    updated = Grid.update(grid, %Point{x: 1, y: 2}, "x")
    |> Grid.to_string
    assert updated == ".x.\no.o\n!x!"

    updated = Grid.update(grid, %Point{x: 3, y: 0}, ".")
    |> Grid.to_string
    assert updated == ".x..\no.o\n!!!"
  end
end
