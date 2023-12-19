defmodule RangeExTests do
  use ExUnit.Case, async: true

  test "intersection/1" do
    assert RangeEx.intersection([1..3, 2..5]) == [2..3]
    assert RangeEx.intersection([1..4, 2..3]) == [2..3]
    assert RangeEx.intersection([1..2, 4..5]) == [0..-1//1]
  end

  test "intersection/2" do
    assert RangeEx.intersection(1..3, 2..5) == 2..3
    assert RangeEx.intersection(1..4, 2..3) == 2..3
    assert RangeEx.intersection(1..2, 4..5) == 0..-1//1
  end

  test "union/1 one range" do
    assert RangeEx.union([1..3]) == [1..3]
  end

  test "union/1 consolidate" do
    assert RangeEx.union([1..2, 3..4]) == [1..4]
    assert RangeEx.union([1..2, 5..6, 3..4]) == [1..6]
  end

  test "union/1 no overlap" do
    assert RangeEx.union([1..2, 4..5]) == [1..2, 4..5]
  end

  test "union/1 overlap" do
    assert RangeEx.union([1..3, 2..4]) == [1..4]
  end

  test "union/1 subset" do
    assert RangeEx.union([1..4, 2..3]) == [1..4]
  end
end
