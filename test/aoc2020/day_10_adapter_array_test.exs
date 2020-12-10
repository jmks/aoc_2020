defmodule Aoc2020.Day10AdapterArrayTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day10AdapterArray

  test "generate pairs" do
    assert generate_pairs([1,2,3]) == [{1,2}, {2, 3}]
    assert generate_pairs([1,2,3,4]) == [{1,2}, {2, 3}, {3, 4}]
  end

  test "joltage difference frequencies" do
    adapters = [
      16, 10, 15, 5, 1,
      11, 7, 19, 6, 12, 4
    ]

    assert %{1 => 7, 3 => 5} == joltage_difference_frequencies(adapters)

    adapters = [
      28, 33, 18, 42,
      31, 14, 46, 20,
      48, 47, 24, 23,
      49, 45, 19, 38,
      39, 11, 1, 32,
      25, 35, 8, 17,
      7, 9, 4, 2,
      34, 10, 3
    ]

    assert %{1 => 22, 3 => 10} == joltage_difference_frequencies(adapters)
  end

  test "solve part 1" do
    %{1 => ones, 3 => threes} = joltage_difference_frequencies(Input.ints(10))

    IO.puts("")
    IO.puts("Part 1: #{ones * threes}")
  end
end
