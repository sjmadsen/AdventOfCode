defmodule Path2dTests do
  use ExUnit.Case, async: true

  test "area/1" do
    path = [Point.new(0, 0), Point.new(5, 0), Point.new(5, 3), Point.new(0, 3)]
    assert Path2d.area(path) == 15
    assert Path2d.area(Enum.reverse(path)) == 15
  end

  test "perimeter/1" do
    path = [Point.new(0, 0), Point.new(5, 0), Point.new(5, 3), Point.new(0, 3)]
    assert Path2d.perimeter(path) == 16
  end
end
