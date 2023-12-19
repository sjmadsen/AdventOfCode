defmodule PointTests do
  use ExUnit.Case, async: true

  test "new/2" do
    assert Point.new(0, 1) == %Point{x: 0, y: 1}
  end

  test "add/2" do
    assert Point.add(Point.new(1, 2), Point.new(1, 1)) == Point.new(2, 3)
  end

  test "mul/2" do
    assert Point.mul(Point.new(1, 2), Point.new(2, 2)) == Point.new(2, 4)
  end
end
