defmodule Aoc2020.Day18OperationOrderTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day18OperationOrder

  test "parsing" do
    assert parse("1 + 2 * 3 + 4 * 5 + 6") == {:add, {:mul, {:add, {:mul, {:add, 1, 2}, 3}, 4}, 5}, 6}
    assert parse("1 + (2 * 3) + (4 * (5 + 6))") == {:add, {:add, 1, {:mul, 2, 3}}, {:mul, 4, {:add, 5, 6}}}
  end

  test "evaluating" do
    assert eval({:add, {:mul, {:add, {:mul, {:add, 1, 2}, 3}, 4}, 5}, 6}) == 71
    assert eval({:add, {:add, 1, {:mul, 2, 3}}, {:mul, 4, {:add, 5, 6}}}) == 51

    assert ("2 * 3 + (4 * 5)" |> parse |> eval) == 26
    assert ("5 + (8 * 3 + 9 + 3 * 4 * 3)" |> parse |> eval) == 437
    assert ("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" |> parse |> eval) == 12240
    assert ("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" |> parse |> eval) == 13632
  end

  test "part 1" do
    result =
      Input.strings(18)
      |> Enum.map(&parse/1)
      |> Enum.map(&eval/1)
      |> Enum.reduce(0, &Kernel.+/2)

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end
end
