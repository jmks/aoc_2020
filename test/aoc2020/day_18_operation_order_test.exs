defmodule Aoc2020.Day18OperationOrderTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day18OperationOrder

  test "parsing" do
    assert parse("1 + 2 * 3 + 4 * 5 + 6") == [1, :add, 2, :mul, 3, :add, 4, :mul, 5, :add, 6]
    assert parse("1 + (2 * 3) + (4 * (5 + 6))") == [
      1,
      :add,
      {:parens, [2, :mul, 3]},
      :add,
      {:parens, [4, :mul, {:parens, [5, :add, 6]}]}
    ]
  end

  test "evaluating" do
    assert ("1 + 2 * 3 + 4 * 5 + 6" |> parse |> eval) == 71
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

  test "multiplication first" do
    assert ("2 * 3 + (4 * 5)" |> parse |> eval2) == 46
    assert ("5 + (8 * 3 + 9 + 3 * 4 * 3)" |> parse |> eval2) == 1445
    assert ("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" |> parse |> eval2) == 669060
    assert ("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" |> parse |> eval2) == 23340
  end

  test "part 2" do
    result =
      Input.strings(18)
      |> Enum.map(&parse/1)
      |> Enum.map(&eval2/1)
      |> Enum.reduce(0, &Kernel.+/2)

    IO.puts("")
    IO.puts("Part 2: #{result}")
  end
end
