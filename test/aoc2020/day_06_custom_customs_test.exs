defmodule Aoc2020.Day06CustomCustomsTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day06CustomCustoms

  @test """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """ |> String.split("\n")

  test "groups" do
    assert length(groups(@test)) == 5
  end

  test "any yes" do
    assert sum_of_any_yes(@test) == 11
  end

  test "solve part 1" do
    result = sum_of_any_yes(Input.strings(6))

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end

  test "all yes" do
    assert sum_of_all_yes(@test) == 6
  end

  test "solve part 2" do
    result = sum_of_all_yes(Input.strings(6))

    IO.puts("")
    IO.puts("Part 2: #{result}")
  end
end
