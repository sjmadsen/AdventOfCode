defmodule Point3Tests do
  use ExUnit.Case, async: true

  test "new/2" do
    assert Point3.new(0, 1, 2) == %Point3{x: 0, y: 1, z: 2}
  end

  test "add/2" do
    assert Point3.add(Point3.new(1, 2, 3), Point3.new(1, 1, 1)) == Point3.new(2, 3, 4)
  end

  test "mul/2" do
    assert Point3.mul(Point3.new(1, 2, 3), Point3.new(2, 2, 2)) == Point3.new(2, 4, 6)
  end
end
