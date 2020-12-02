defmodule Aoc2020.Day02PasswordPhilosophyTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day02PasswordPhilosophy
  alias Aoc2020.Day02PasswordPhilosophy

  test "valid passwords by count in range" do
    assert validate_by_letter_count("1-3 a: abcde")
    refute validate_by_letter_count("1-3 b: cdefg")
    assert validate_by_letter_count("2-9 c: ccccccccc")
  end

  test "solve part 1" do
    count = count_valid(&Day02PasswordPhilosophy.letter_count/2, Input.strings(2))

    IO.puts("")
    IO.puts("Part 1: #{count}")
  end

  test "valid passwords by position" do
    assert validate_by_letter_positions("1-3 a: abcde")
    refute validate_by_letter_positions("1-3 b: cdefg")
    refute validate_by_letter_positions("2-9 c: ccccccccc")
  end

  test "solve part 2" do
    count = count_valid(&Day02PasswordPhilosophy.letter_positions/2, Input.strings(2))

    IO.puts("")
    IO.puts("Part 2: #{count}")
  end
end
