defmodule Aoc2020.Day16TicketTranslationTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day16TicketTranslation
  alias Aoc2020.Day16TicketTranslation.Info

  @test """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """ |> String.split("\n")

  @test2 """
  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9
  """ |> String.split("\n")

  test "parsing" do
    assert Info.parse(@test) == %Info{
      constraints: %{
        "class" => [1..3, 5..7],
        "row" => [6..11, 33..44],
        "seat" => [13..40, 45..50]
      },
      mine: [7, 1, 14],
      nearby: [
        [7, 3, 47],
        [40, 4, 50],
        [55, 2, 20],
        [38, 6, 12]
      ]
    }
  end

  test "error rate" do
    assert scanning_error_rate(Info.parse(@test)) == 71
  end

  test "part 1" do
    result = scanning_error_rate(Info.parse(Input.strings(16)))

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end

  test "column assignments" do
    info = @test2 |> Info.parse |> Info.discard_invalid_tickets

    assert Info.column_assignment(info) == ["row", "class", "seat"]
  end

  test "part 2" do
    info =
      Input.strings(16)
      |> Info.parse
      |> Info.discard_invalid_tickets

    result =
    info
    |> Info.column_assignment
    |> Enum.zip(info.mine)
    |> Enum.filter(fn {field, _} -> String.starts_with?(field, "departure") end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(1, &Kernel.*/2)

    IO.puts("")
    IO.puts("Part 2: #{result}")
  end
end
