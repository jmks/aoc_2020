defmodule Aoc2020.Day23CrabCups do
  @moduledoc """
  --- Day 23: Crab Cups ---
  The small crab challenges you to a game! The crab is going to mix up some cups, and you have to predict where they'll end up.

  The cups will be arranged in a circle and labeled clockwise (your puzzle input). For example, if your labeling were 32415, there would be five cups in the circle; going clockwise around the circle from the first cup, the cups would be labeled 3, 2, 4, 1, 5, and then back to 3 again.

  Before the crab starts, it will designate the first cup in your list as the current cup. The crab is then going to do 100 moves.

  Each move, the crab does the following actions:

  The crab picks up the three cups that are immediately clockwise of the current cup. They are removed from the circle; cup spacing is adjusted as necessary to maintain the circle.
  The crab selects a destination cup: the cup with a label equal to the current cup's label minus one. If this would select one of the cups that was just picked up, the crab will keep subtracting one until it finds a cup that wasn't just picked up. If at any point in this process the value goes below the lowest value on any cup's label, it wraps around to the highest value on any cup's label instead.
  The crab places the cups it just picked up so that they are immediately clockwise of the destination cup. They keep the same order as when they were picked up.
  The crab selects a new current cup: the cup which is immediately clockwise of the current cup.
  For example, suppose your cup labeling were 389125467. If the crab were to do merely 10 moves, the following changes would occur:

  -- move 1 --
  cups: (3) 8  9  1  2  5  4  6  7
  pick up: 8, 9, 1
  destination: 2

  -- move 2 --
  cups:  3 (2) 8  9  1  5  4  6  7
  pick up: 8, 9, 1
  destination: 7

  -- move 3 --
  cups:  3  2 (5) 4  6  7  8  9  1
  pick up: 4, 6, 7
  destination: 3

  -- move 4 --
  cups:  7  2  5 (8) 9  1  3  4  6
  pick up: 9, 1, 3
  destination: 7

  -- move 5 --
  cups:  3  2  5  8 (4) 6  7  9  1
  pick up: 6, 7, 9
  destination: 3

  -- move 6 --
  cups:  9  2  5  8  4 (1) 3  6  7
  pick up: 3, 6, 7
  destination: 9

  -- move 7 --
  cups:  7  2  5  8  4  1 (9) 3  6
  pick up: 3, 6, 7
  destination: 8

  -- move 8 --
  cups:  8  3  6  7  4  1  9 (2) 5
  pick up: 5, 8, 3
  destination: 1

  -- move 9 --
  cups:  7  4  1  5  8  3  9  2 (6)
  pick up: 7, 4, 1
  destination: 5

  -- move 10 --
  cups: (5) 7  4  1  8  3  9  2  6
  pick up: 7, 4, 1
  destination: 3

  -- final --
  cups:  5 (8) 3  7  4  1  9  2  6

  In the above example, the cups' values are the labels as they appear moving clockwise around the circle; the current cup is marked with ( ).

  After the crab is done, what order will the cups be in? Starting after the cup labeled 1, collect the other cups' labels clockwise into a single string with no extra characters; each number except 1 should appear exactly once. In the above example, after 10 moves, the cups clockwise from 1 are labeled 9, 2, 6, 5, and so on, producing 92658374. If the crab were to complete all 100 moves, the order after cup 1 would be 67384529.

  Using your labeling, simulate 100 moves. What are the labels on the cups after cup 1?

  --- Part Two ---
  Due to what you can only assume is a mistranslation (you're not exactly fluent in Crab), you are quite surprised when the crab starts arranging many cups in a circle on your raft - one million (1000000) in total.

  Your labeling is still correct for the first few cups; after that, the remaining cups are just numbered in an increasing fashion starting from the number after the highest number in your list and proceeding one by one until one million is reached. (For example, if your labeling were 54321, the cups would be numbered 5, 4, 3, 2, 1, and then start counting up from 6 until one million is reached.) In this way, every number from one through one million is used exactly once.

  After discovering where you made the mistake in translating Crab Numbers, you realize the small crab isn't going to do merely 100 moves; the crab is going to do ten million (10000000) moves!

  The crab is going to hide your stars - one each - under the two cups that will end up immediately clockwise of cup 1. You can have them if you predict what the labels on those cups will be when the crab is finished.

  In the above example (389125467), this would be 934001 and then 159792; multiplying these together produces 149245887792.

  Determine which two cups will end up immediately clockwise of cup 1. What do you get if you multiply their labels together?
  """
  defmodule CyclicZipperList do
    def new(list) do
      {[], list}
    end

    def current({_, next}), do: hd(next)

    def to_list({prev, next}) do
      next ++ Enum.reverse(prev)
    end

    def next({prev, []}) do
      {[], Enum.reverse(prev)}
    end

    def next({prev, [last]}) do
      half = div(length(prev) + 1, 2)
      new_prev = Enum.take([last | prev], half)
      new_next = Enum.drop([last | prev], half) |> Enum.reverse

      {new_prev, new_next}
    end

    def next({prev, [current | next]}) do
      {[current | prev], next}
    end

    def previous({[], next}) do
      half = div(length(next), 2)
      new_next = Enum.take(next, half)
      [new_current | new_prev] = Enum.drop(next, half) |> Enum.reverse

      {new_prev, [new_current | new_next]}
    end

    def previous({[p | prest], next}) do
      {prest, [p | next]}
    end

    def next_until({_, [current | _]} = zip, current) do
      zip
    end

    def next_until(zip, target) do
      next_until(next(zip), target)
    end

    def slice({prev, next}, count) when length(next) > count do
      sliced = Enum.take(next, count)
      new_next = Enum.drop(next, count)

      {sliced, {prev, new_next}}
    end

    def slice({prev, next}, count) when length(next) == count do
      {next, {[], Enum.reverse(prev)}}
    end

    def slice({prev, next}, count) do
      reversed_prev = Enum.reverse(prev)
      sliced = next ++ Enum.take(reversed_prev, count - length(next))

      {sliced, {[], Enum.drop(reversed_prev, count - length(next))}}
    end

    def slice_after_current(zip, count) do
      {sliced, new_zip} = zip |> next |> slice(count)

      {sliced, previous(new_zip)}
    end

    def insert_after_current({prev, [current | crest]}, values) do
      {prev, [current | values] ++ crest}
    end
  end

  defmodule Circle do
    defstruct [:zip]

    def new(cups), do: %__MODULE__{zip: CyclicZipperList.new(cups)}

    def move(circle) do
      current = CyclicZipperList.current(circle.zip)

      {removed, zip} = CyclicZipperList.slice_after_current(circle.zip, 3)
      destination = find_destination(current - 1, CyclicZipperList.to_list(zip))
      new_zip =
        zip
        |> CyclicZipperList.next_until(destination)
        |> CyclicZipperList.insert_after_current(removed)
        |> CyclicZipperList.next_until(current)
        |> CyclicZipperList.next

      %{circle | zip: new_zip}
    end

    def cups(circle) do
      circle.zip
      |> CyclicZipperList.next_until(1)
      |> CyclicZipperList.to_list
      |> tl
    end

    def current(circle) do
      CyclicZipperList.current(circle.zip)
    end

    defp find_destination(target, rest) do
      rest_lookup = MapSet.new(rest)

      do_find_destination(target, rest_lookup)
    end

    defp do_find_destination(non_positive, rest_lookup) when non_positive <= 0 do
      rest_lookup
      |> Enum.into([])
      |> Enum.max
    end

    defp do_find_destination(target, rest_lookup) do
      if MapSet.member?(rest_lookup, target) do
        target
      else
        do_find_destination(target - 1, rest_lookup)
      end
    end
  end

  defmodule QuickCircle do
    defstruct [:successors, :current, :top_values]

    def new(cups) do
      successors = with_successor(cups, hd(cups)) |> Enum.into(%{})
      top_values = Enum.sort(cups, :desc) |> Enum.take(4)

      %__MODULE__{successors: successors, current: hd(cups), top_values: top_values}
    end

    def move(qc) do
      [head, _, last] = removed = read(qc, qc.current, 3)

      dest = destination(qc.current - 1, removed, qc.top_values)
      dest_next = Map.get(qc.successors, dest)

      new_successors =
        qc.successors
        |> Map.put(qc.current, Map.get(qc.successors, last))
        |> Map.put(dest, head)
        |> Map.put(last, dest_next)

      %{qc | successors: new_successors, current: Map.get(new_successors, qc.current)}
    end

    def cups(qc) do
      read(qc, 1, map_size(qc.successors))
      |> Enum.reverse
      |> tl
      |> Enum.reverse
    end

    defp read(_qc, _curr, 0), do: []

    defp read(qc, curr, count) do
      next = Map.get(qc.successors, curr)

      [next | read(qc, next, count - 1)]
    end

    defp with_successor([last], first), do: [{last, first}]
    defp with_successor([current, succ | rest], first) do
      [{current, succ} | with_successor([succ | rest], first)]
    end

    defp destination(0, removed, top_values) do
      hd(top_values -- removed)
    end

    defp destination(value, removed, top_values) do
      if value in removed do
        destination(value - 1, removed, top_values)
      else
        value
      end
    end
  end

  def go_crab(initial_digits) do
    max = Enum.max(initial_digits)
    cups = initial_digits ++ Enum.to_list((max+1)..1_000_000)
    total_moves = 10_000_000
    circle = QuickCircle.new(cups) |> quick_moves(total_moves)

    QuickCircle.cups(circle)
    |> Enum.take(2)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  def moves(circle, 0), do: circle
  def moves(circle, count) do
    circle |> Circle.move |> moves(count - 1)
  end

  def quick_moves(circle, 0), do: circle
  def quick_moves(circle, count) do
    circle |> QuickCircle.move |> quick_moves(count - 1)
  end
end
