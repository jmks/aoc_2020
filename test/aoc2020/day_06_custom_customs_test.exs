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

  test "yeses" do
    assert sum_of_group_yes(@test) == 11
  end

  test "solve part 1" do
    result = sum_of_group_yes(Input.strings(6))

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end
end
