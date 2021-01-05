defmodule Aoc2020.Day23CrabCupsTest do
  use ExUnit.Case, async: true

  alias Aoc2020.Day23CrabCups.{Circle, CyclicZipperList}

  test "cyclic zip list" do
    zip = CyclicZipperList.new([1,2,3,4])

    assert CyclicZipperList.current(zip) == 1
    assert CyclicZipperList.next_until(zip, 3) == {[2, 1], [3, 4]}
    assert CyclicZipperList.next(zip) |> CyclicZipperList.slice(3) == {[2, 3, 4], {[], [1]}}
    assert CyclicZipperList.next_until(zip, 4) |> CyclicZipperList.insert_after_current([5,6,7]) == {[3, 2, 1], [4, 5, 6, 7]}

    assert CyclicZipperList.previous(zip) == {[3], [4, 1, 2]}
    assert CyclicZipperList.next_until(zip, 4) == {[3, 2, 1], [4]}
    assert CyclicZipperList.next_until(zip, 4) |> CyclicZipperList.next == {[4, 3], [1,2]}

    assert CyclicZipperList.slice_after_current(zip, 2) == {[2, 3], {[], [1, 4]}}
    assert zip |> CyclicZipperList.next_until(3) |> CyclicZipperList.slice_after_current(3) == {[4, 1, 2], {[], [3]}}
  end

  test "a move" do
    original = 389125467
      |> Integer.digits
      |> Circle.new

    circle = Circle.move(original)
    assert Circle.current(circle) == 2
    assert Circle.cups(circle) == Integer.digits(54673289)

    circle = Circle.move(circle)
    assert Circle.current(circle) == 5
    assert Circle.cups(circle) == Integer.digits(32546789)

    circle = Circle.move(circle)
    assert Circle.current(circle) == 8
    assert Circle.cups(circle) == Integer.digits(34672589)

    assert moves(original, 10) |> Circle.cups == Integer.digits(92658374)
    assert moves(original, 100) |> Circle.cups == Integer.digits(67384529)
  end

  test "part 1" do
    result =
      Input.ints(23)
      |> hd
      |> Integer.digits
      |> Circle.new
      |> moves(100)
      |> Circle.cups
      |> Integer.undigits

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end

  defp moves(circle, 0), do: circle

  defp moves(circle, count) do
    circle |> Circle.move |> moves(count - 1)
  end
end
