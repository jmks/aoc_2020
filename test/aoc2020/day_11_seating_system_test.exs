defmodule Aoc2020.Day11SeatingSystemTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day11SeatingSystem
  alias Aoc2020.Day11SeatingSystem.Seats

  @test_grid """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  test "the truth" do
    seats = Seats.new(@test_grid |> String.split("\n", trim: true))

    assert Seats.at(seats, 0, 0) == :empty
    assert Seats.at(seats, 0, 1) == :floor
  end

  test "arrivals" do
    seats = Seats.new(@test_grid |> String.split("\n", trim: true))
    new_seats = Seats.round_of_arrivals(seats)

    assert Seats.at(new_seats, 0, 0) == :occupied
  end

  test "arrivals until stable" do
    seats = Seats.new(@test_grid |> String.split("\n", trim: true))
    stable_seats = arrivals_until_stable(seats)

    assert Seats.occupied(stable_seats) == 37
  end

  test "solve part 1" do
    seats = Seats.new(Input.strings(11)) |> arrivals_until_stable

    IO.puts("")
    IO.puts("Part 1: #{Seats.occupied(seats)}")
  end

  defp arrivals_until_stable(seats) do
    new_seats = Seats.round_of_arrivals(seats)

    if Seats.changes?(new_seats) do
      arrivals_until_stable(new_seats)
    else
      new_seats
    end
  end
end
