defmodule Aoc2020.Day12RainRisk do
  @moduledoc """
  --- Day 12: Rain Risk ---
  Your ferry made decent progress toward the island, but the storm came in faster than anyone expected. The ferry needs to take evasive actions!

  Unfortunately, the ship's navigation computer seems to be malfunctioning; rather than giving a route directly to safety, it produced extremely circuitous instructions. When the captain uses the PA system to ask if anyone can help, you quickly volunteer.

  The navigation instructions (your puzzle input) consists of a sequence of single-character actions paired with integer input values. After staring at them for a few minutes, you work out what they probably mean:

  Action N means to move north by the given value.
  Action S means to move south by the given value.
  Action E means to move east by the given value.
  Action W means to move west by the given value.
  Action L means to turn left the given number of degrees.
  Action R means to turn right the given number of degrees.
  Action F means to move forward by the given value in the direction the ship is currently facing.

  The ship starts by facing east. Only the L and R actions change the direction the ship is facing. (That is, if the ship is facing east and the next instruction is N10, the ship would move north 10 units, but would still move east if the following action were F.)

  For example:

  F10
  N3
  F7
  R90
  F11

  These instructions would be handled as follows:

  F10 would move the ship 10 units east (because the ship starts by facing east) to east 10, north 0.
  N3 would move the ship 3 units north to east 10, north 3.
  F7 would move the ship another 7 units east (because the ship is still facing east) to east 17, north 3.
  R90 would cause the ship to turn right by 90 degrees and face south; it remains at east 17, north 3.
  F11 would move the ship 11 units south to east 17, south 8.

  At the end of these instructions, the ship's Manhattan distance (sum of the absolute values of its east/west position and its north/south position) from its starting position is 17 + 8 = 25.

  Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the ship's starting position?
  """
  defmodule Ship do
    defstruct [:direction, :north, :east]

    def new do
      %__MODULE__{direction: :east, north: 0, east: 0}
    end

    def follow(ship, instruction) do
      {new_direction, north, east} = move(ship.direction, instruction)

      %{ship | direction: new_direction, north: ship.north + north, east: ship.east + east}
    end

    def distance_travelled(ship) do
      abs(ship.north) + abs(ship.east)
    end

    defp move(direction, {:north, distance}), do: {direction, distance, 0}
    defp move(direction, {:south, distance}), do: {direction, -distance, 0}
    defp move(direction, {:east, distance}),  do: {direction, 0, distance}
    defp move(direction, {:west, distance}),  do: {direction, 0, -distance}
    defp move(direction, {:left,  degrees}),  do: {turn(direction, :left, degrees), 0, 0}
    defp move(direction, {:right, degrees}),  do: {turn(direction, :right, degrees), 0, 0}
    defp move(direction, {:forward, distance}), do: move(direction, {direction, distance})

    defp turn(direction, :right, deg), do: rotate(direction, deg)
    defp turn(direction, :left,  deg), do: rotate(direction, 360 - deg)

    defp rotate(:north, 90), do: :east
    defp rotate(:north, 180), do: :south
    defp rotate(:north, 270), do: :west
    defp rotate(:east, 90), do: :south
    defp rotate(:east, 180), do: :west
    defp rotate(:east, 270), do: :north
    defp rotate(:south, 90), do: :west
    defp rotate(:south, 180), do: :north
    defp rotate(:south, 270), do: :east
    defp rotate(:west, 90), do: :north
    defp rotate(:west, 180), do: :east
    defp rotate(:west, 270), do: :south
  end

  def parse_instruction("N" <> units), do: {:north, parse_int(units)}
  def parse_instruction("E" <> units), do: {:east, parse_int(units)}
  def parse_instruction("S" <> units), do: {:south, parse_int(units)}
  def parse_instruction("W" <> units), do: {:west, parse_int(units)}
  def parse_instruction("R" <> units), do: {:right, parse_int(units)}
  def parse_instruction("L" <> units), do: {:left, parse_int(units)}
  def parse_instruction("F" <> units), do: {:forward, parse_int(units)}

  defp parse_int(str) do
    {int, ""} = Integer.parse(str)
    int
  end
end
