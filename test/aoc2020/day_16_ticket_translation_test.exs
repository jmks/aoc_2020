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
end
