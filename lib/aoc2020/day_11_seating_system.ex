defmodule Aoc2020.Day11SeatingSystem do
  @moduledoc """
  --- Day 11: Seating System ---
  Your plane lands with plenty of time to spare. The final leg of your journey is a ferry that goes directly to the tropical island where you can finally start your vacation. As you reach the waiting area to board the ferry, you realize you're so early, nobody else has even arrived yet!

  By modeling the process people use to choose (or abandon) their seat in the waiting area, you're pretty sure you can predict the best place to sit. You make a quick map of the seat layout (your puzzle input).

  The seat layout fits neatly on a grid. Each position is either floor (.), an empty seat (L), or an occupied seat (#). For example, the initial seat layout might look like this:

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

  Now, you just need to model the people who will be arriving shortly. Fortunately, people are entirely predictable and always follow a simple set of rules. All decisions are based on the number of occupied seats adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the seat). The following rules are applied to every seat simultaneously:

  If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  Otherwise, the seat's state does not change.
  Floor (.) never changes; seats don't move, and nobody sits on the floor.

  After one round of these rules, every seat in the example layout becomes occupied:

  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##

  After a second round, the seats with four or more occupied adjacent seats become empty again:

  #.LL.L#.##
  #LLLLLL.L#
  L.L.L..L..
  #LLL.LL.L#
  #.LL.LL.LL
  #.LLLL#.##
  ..L.L.....
  #LLLLLLLL#
  #.LLLLLL.L
  #.#LLLL.##

  This process continues for three more rounds:

  #.##.L#.##
  #L###LL.L#
  L.#.#..#..
  #L##.##.L#
  #.##.LL.LL
  #.###L#.##
  ..#.#.....
  #L######L#
  #.LL###L.L
  #.#L###.##

  #.#L.L#.##
  #LLL#LL.L#
  L.L.L..#..
  #LLL.##.L#
  #.LL.LL.LL
  #.LL#L#.##
  ..L.L.....
  #L#LLLL#L#
  #.LLLLLL.L
  #.#L#L#.##

  #.#L.L#.##
  #LLL#LL.L#
  L.#.L..#..
  #L##.##.L#
  #.#L.LL.LL
  #.#L#L#.##
  ..L.L.....
  #L#L##L#L#
  #.LLLLLL.L
  #.#L#L#.##

  At this point, something interesting happens: the chaos stabilizes and further applications of these rules cause no seats to change state! Once people stop moving around, you count 37 occupied seats.

  Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats end up occupied?
  """

  defmodule Seats do
    defstruct [:width, :height, :seats]

    def new(seat_layout) do
      width = hd(seat_layout) |> String.length()
      height = length(seat_layout)
      seats = parse_seats(seat_layout)

      %__MODULE__{width: width, height: height, seats: seats}
    end

    def at(seats, row, col) do
      Map.get(seats.seats, {row, col})
    end

    def round_of_arrivals(seats) do
      new_seats =
        seats
        |> positions
        |> Enum.reduce(%{seat_change: false}, fn {row, col}, map ->
          {changed, new_state} = update_position(seats.seats, row, col)
          new_changes = Map.get(map, :seat_change) or changed

          map
          |> Map.put({row, col}, new_state)
          |> Map.put(:seat_change, new_changes)
      end)

      %{seats | seats: new_seats}
    end

    def occupied(seats) do
      seats
      |> positions
      |> Enum.count(fn position ->
        case Map.get(seats.seats, position) do
          :occupied -> true
          _ -> false
        end
      end)
    end

    def changes?(seats) do
      Map.get(seats.seats, :seat_change)
    end

    defp parse_seats(layout) do
      layout
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, row_index}, map ->
        row
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reduce(map, fn {char, col_index}, map ->
          state = char_to_state(char)
          Map.put(map, {row_index, col_index}, state)
        end)
      end)
    end

    defp char_to_state("L"), do: :empty
    defp char_to_state("#"), do: :occupied
    defp char_to_state("."), do: :floor

    defp positions(seats) do
      for row <- 0..(seats.height - 1),
          col <- 0..(seats.width - 1) do
            {row, col}
      end
    end

    defp update_position(seats, row, col) do
      current = Map.get(seats, {row, col})
      occupied =
        adjacent_positions(row, col)
        |> Enum.map(&Map.get(seats, &1, :out_of_bounds))
        |> Enum.filter(fn
          :occupied -> true
          _ -> false
        end)
        |> length
      updated = update_position(current, occupied)

      # IO.puts("#{row}, #{col} is #{inspect current} with #{occupied} neighbours but will be #{update_position(current, occupied)}")
      {current != updated, updated}
    end

    defp adjacent_positions(row, col) do
      [
        {row + 1, col},
        {row + 1, col + 1},
        {row + 1, col - 1},
        {row - 1, col},
        {row - 1, col + 1},
        {row - 1, col - 1},
        {row, col + 1},
        {row, col - 1}
      ]
    end

    defp update_position(:empty, 0), do: :occupied
    defp update_position(:occupied, neighbours) when neighbours >= 4, do: :empty
    defp update_position(unchanged, _), do: unchanged
  end
end
