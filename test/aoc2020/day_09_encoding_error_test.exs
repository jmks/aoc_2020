defmodule Aoc2020.Day09EncodingErrorTest do
  use ExUnit.Case, async: true

  alias Aoc2020.Day09EncodingError.TwoSumSlidingWindow
  import Aoc2020.Day09EncodingError

  @values [
    35,   20,  15,  25,  47,
    40,   62,  55,  65,  95,
    102, 117, 150, 182, 127,
    219, 299, 277, 309, 576
  ]

  test "finds first number that does not have two number summing to it" do
    two_sum = TwoSumSlidingWindow.new(5, @values)
    found = find_first_invalid(two_sum, Enum.drop(@values, 5))

    assert found == 127
  end

  test "solve" do
    values = Input.ints(9)
    preamble = Enum.take(values, 25)
    rest = Enum.drop(values, 25)

    two_sum = TwoSumSlidingWindow.new(25, preamble)
    found = find_first_invalid(two_sum, rest)

    IO.puts("")
    IO.puts("Part 1: #{found}")

    range = find_rolling_sum_of(found, values)
    IO.puts("")
    IO.puts("Part 2: #{encryption_weakness(range)}")
  end

  test "rolling sum" do
    range = find_rolling_sum_of(127, @values)

    assert range
    assert encryption_weakness(range) == 62
  end

  defp encryption_weakness(range) do
    sorted = Enum.sort(range)

    hd(sorted) + List.last(sorted)
  end
end
