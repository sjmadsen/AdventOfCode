defmodule PriorityQueue do
  defstruct [:set]

  def new(), do: %__MODULE__{set: :gb_sets.empty()}
  def new([]), do: new()
  def new([{_prio, _elem} | _] = list), do: %__MODULE__{set: :gb_sets.from_list(list)}

  def add_with_priority(%__MODULE__{} = q, elem, prio) do
    %{q | set: :gb_sets.add({prio, elem}, q.set)}
  end

  def size(%__MODULE__{} = q) do
    :gb_sets.size(q.set)
  end

  def extract_min(%__MODULE__{} = q) do
    case :gb_sets.size(q.set) do
      0 -> nil
      _else ->
        {{prio, elem}, set} = :gb_sets.take_smallest(q.set)
        {{prio, elem}, %{q | set: set}}
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%PriorityQueue{} = q, opts) do
      concat(["#PrioQ.new(", to_doc(:gb_sets.to_list(q.set), opts), ")"])
    end
  end
end
