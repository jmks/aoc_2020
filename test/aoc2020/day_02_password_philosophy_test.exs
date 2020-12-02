defmodule Aoc2020.Day02PasswordPhilosophyTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day02PasswordPhilosophy

  test "valid passwords by count in range" do
    assert validate_password(:letter_count, "1-3 a: abcde")
    refute validate_password(:letter_count, "1-3 b: cdefg")
    assert validate_password(:letter_count, "2-9 c: ccccccccc")
  end

  test "count_valid" do
    assert count_valid(:letter_count, ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]) == 2
  end

  test "solve part 1" do
    count = count_valid(:letter_count, Input.strings(2))

    IO.puts("")
    IO.puts("Part 1: #{count}")
  end

  test "valid passwords by position" do
    assert validate_password(:letter_positions, "1-3 a: abcde")
    refute validate_password(:letter_positions, "1-3 b: cdefg")
    refute validate_password(:letter_positions, "2-9 c: ccccccccc")
  end

  test "solve part 2" do
    count = count_valid(:letter_positions, Input.strings(2))

    IO.puts("")
    IO.puts("Part 2: #{count}")
  end
end
