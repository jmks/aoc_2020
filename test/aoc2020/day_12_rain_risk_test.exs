defmodule Aoc2020.Day12RainRiskTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day12RainRisk
  alias Aoc2020.Day12RainRisk.{Ship, Waypoint, Displacement}

  test "parsing instructions" do
    assert parse_instruction("W1") == {:west, 1}
    assert parse_instruction("N3") == {:north, 3}
    assert parse_instruction("S7") == {:south, 7}
    assert parse_instruction("E2") == {:east, 2}
    assert parse_instruction("R88") == {:right, 88}
    assert parse_instruction("L29") == {:left, 29}
    assert parse_instruction("F91") == {:forward, 91}
  end

  test "ship distance" do
    ship =
      test_instructions()
      |> Enum.reduce(Ship.new, &Ship.follow(&2, &1))

    assert ship.north == -8
    assert ship.east == 17
    assert Ship.distance_travelled(ship) == 25
  end

  test "part 1" do
    distance =
      Input.strings(12)
      |> Enum.map(&parse_instruction/1)
      |> Enum.reduce(Ship.new, &Ship.follow(&2, &1))
      |> Ship.distance_travelled

    IO.puts("")
    IO.puts("Part 1: #{distance}")
  end

  test "follow the waypoint" do
    waypoint =
      test_instructions()
      |> Enum.reduce(Waypoint.new, fn instr, waypoint ->
        new_waypoint = Waypoint.navigate(waypoint, instr)

        new_waypoint
      end)

    assert Waypoint.distance_travelled(waypoint) == 286
  end

  test "part 2" do
    result =
      Input.strings(12)
      |> Enum.map(&parse_instruction/1)
      |> Enum.reduce(Waypoint.new, fn instr, waypoint ->
        Waypoint.navigate(waypoint, instr)
      end)
      |> Waypoint.distance_travelled

    IO.puts("")
    IO.puts("Part 2: #{result}")
  end

  def test_instructions do
    """
    F10
    N3
    F7
    R90
    F11
    """
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end
end
