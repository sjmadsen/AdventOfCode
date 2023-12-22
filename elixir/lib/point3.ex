defmodule Point3 do
  defstruct [:x, :y, :z]

  def new(x, y, z), do: %Point3{x: x, y: y, z: z}

  def add(%Point3{} = p1, %Point3{} = p2) do
    Point3.new(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)
  end

  def mul(%Point3{} = p1, %Point3{} = p2) do
    Point3.new(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z)
  end
end
