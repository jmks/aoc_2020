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

  --- Part Two ---

  As soon as people start to arrive, you realize your mistake. People don't just care about adjacent seats - they care about the first seat they can see in each of those eight directions!

  Now, instead of considering just the eight immediately adjacent seats, consider the first seat in each of those eight directions. For example, the empty seat below would see eight occupied seats:

  .......#.
  ...#.....
  .#.......
  .........
  ..#L....#
  ....#....
  .........
  #........
  ...#.....
  The leftmost empty seat below would only see one empty seat, but cannot see any of the occupied ones:

  .............
  .L.L.#.#.#.#.
  .............
  The empty seat below would see no occupied seats:

  .##.##.
  #.#.#.#
  ##...##
  ...L...
  ##...##
  #.#.#.#
  .##.##.

  Also, people seem to be more tolerant than you expected: it now takes five or more visible occupied seats for an occupied seat to become empty (rather than four or more from the previous rules). The other rules still apply: empty seats that see no occupied seats become occupied, seats matching no rule don't change, and floor never changes.

  Given the same starting layout as above, these new rules cause the seating area to shift around as follows:

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

  #.LL.LL.L#
  #LLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLL#
  #.LLLLLL.L
  #.LLLLL.L#

  #.L#.##.L#
  #L#####.LL
  L.#.#..#..
  ##L#.##.##
  #.##.#L.##
  #.#####.#L
  ..#.#.....
  LLL####LL#
  #.L#####.L
  #.L####.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##LL.LL.L#
  L.LL.LL.L#
  #.LLLLL.LL
  ..L.L.....
  LLLLLLLLL#
  #.LLLLL#.L
  #.L#LL#.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##L#.#L.L#
  L.L#.#L.L#
  #.L####.LL
  ..#.#.....
  LLL###LLL#
  #.LLLLL#.L
  #.L#LL#.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##L#.#L.L#
  L.L#.LL.L#
  #.LLLL#.LL
  ..#.L.....
  LLL###LLL#
  #.LLLLL#.L
  #.L#LL#.L#

  Again, at this point, people stop shifting around and the seating area reaches equilibrium. Once this occurs, you count 26 occupied seats.

  Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is reached, how many seats end up occupied?
  """
  defmodule Seats do
    defstruct [:width, :height, :seats, :neighbour_strategy]

    def new(seat_layout, neighbour_strategy \\ :adjacent) do
      width = hd(seat_layout) |> String.length()
      height = length(seat_layout)
      seats = parse_seats(seat_layout)

      %__MODULE__{
        width: width,
        height: height,
        neighbour_strategy: neighbour_strategy,
        seats: seats
      }
    end

    def at(seats, row, col) do
      Map.get(seats.seats, {row, col})
    end

    def round_of_arrivals(seats) do
      new_seats =
        seats
        |> positions
        |> Enum.reduce(%{seat_change: false}, fn {row, col}, map ->
          {changed, new_state} = update_position(seats.seats, row, col, seats.neighbour_strategy)
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

    def to_string(seats) do
      seats
      |> positions
      |> Enum.chunk_every(seats.width)
      |> Enum.map(fn row ->
        Enum.map(row, fn position ->
          Map.get(seats.seats, position) |> state_to_char
        end)
        |> Enum.join("")
      end) |> Enum.join("\n")
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

    defp state_to_char(:empty), do: "L"
    defp state_to_char(:occupied), do: "#"
    defp state_to_char(:floor), do: "."

    defp positions(seats) do
      for row <- 0..(seats.height - 1),
          col <- 0..(seats.width - 1) do
            {row, col}
      end
    end

    defp update_position(seats, row, col, strategy) do
      current = Map.get(seats, {row, col})
      occupied_fn = case strategy do
                      :adjacent -> &adjacent_occupied_positions/3
                      :visible -> &visible_occupied_positions/3
                    end
      occupied = occupied_fn.(seats, row, col)
      updated = update_position(current, occupied, strategy)

      {current != updated, updated}
    end

    defp adjacent_occupied_positions(seats, row, col) do
      adjacent_positions(row, col)
      |> Enum.map(&Map.get(seats, &1, :out_of_bounds))
      |> count_occupied
    end

    defp visible_occupied_positions(seats, row, col) do
      slopes()
      |> Enum.map(fn slope ->
        first_seat(seats, {row, col}, slope, 1)
      end)
      |> count_occupied
    end

    defp count_occupied(seats) do
      seats
      |> Enum.filter(fn
        :occupied -> true
        _ -> false
      end)
      |> length
    end

    defp adjacent_positions(row, col) do
      Enum.map(slopes(), fn {dr, dc} ->
        {dr + row, dc + col}
      end)
    end

    defp slopes do
      [
        {1, 0}, {1, 1}, {1, -1},
        {-1, 0}, {-1, 1}, {-1, -1},
        {0, 1}, {0, -1}
      ]
    end

    defp first_seat(seats, {row, col}, {dr, dc}, multiplier) do
      case Map.get(seats, {row + multiplier * dr, col + multiplier * dc}, :out_of_bounds) do
        :floor ->
          first_seat(seats, {row, col}, {dr, dc}, multiplier + 1)

        seat ->
          seat
      end
    end

    defp update_position(:empty, 0, _), do: :occupied
    defp update_position(:occupied, neighbours, :adjacent) when neighbours >= 4, do: :empty
    defp update_position(:occupied, neighbours, :visible) when neighbours >= 5, do: :empty
    defp update_position(unchanged, _, _), do: unchanged
  end
end
