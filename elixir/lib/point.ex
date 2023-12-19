defmodule Point do
  defstruct x: 0, y: 0

  def new(x, y), do: %Point{x: x, y: y}

  def add(%Point{} = p1, %Point{} = p2) do
    new(p1.x + p2.x, p1.y + p2.y)
  end

  def mul(%Point{} = p1, %Point{} = p2) do
    new(p1.x * p2.x, p1.y * p2.y)
  end
end
