defmodule Aoc2020.Day05BinaryBoardingTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day05BinaryBoarding

  test "bsp seat" do
    assert seat("FBFBBFFRLR") == {44, 5}
  end

  test "solve part 1" do
    result =
      Input.strings(5)
      |> Enum.map(fn code -> code |> seat |> seat_id end)
      |> Enum.max

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end
end
