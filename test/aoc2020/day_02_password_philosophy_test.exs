defmodule Aoc2020.Day02PasswordPhilosophyTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day02PasswordPhilosophy

  test "valid passwords" do
    assert validate_password("1-3 a: abcde")
    refute validate_password("1-3 b: cdefg")
    assert validate_password("2-9 c: ccccccccc")
  end

  test "count_valid" do
    assert count_valid(["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]) == 2
  end

  test "solve part 1" do
    count = Input.strings(2) |> count_valid

    IO.puts("")
    IO.puts("Part 1: #{count}")
  end
end
