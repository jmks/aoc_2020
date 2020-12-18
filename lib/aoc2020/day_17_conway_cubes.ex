defmodule Aoc2020.Day17ConwayCubes do
  @moduledoc """
  --- Day 17: Conway Cubes ---
As your flight slowly drifts through the sky, the Elves at the Mythical Information Bureau at the North Pole contact you. They'd like some help debugging a malfunctioning experimental energy source aboard one of their super-secret imaging satellites.

The experimental energy source is based on cutting-edge technology: a set of Conway Cubes contained in a pocket dimension! When you hear it's having problems, you can't help but agree to take a look.

The pocket dimension contains an infinite 3-dimensional grid. At every integer 3-dimensional coordinate (x,y,z), there exists a single cube which is either active or inactive.

In the initial state of the pocket dimension, almost all cubes start inactive. The only exception to this is a small flat region of cubes (your puzzle input); the cubes in this region start in the specified active (#) or inactive (.) state.

The energy source then proceeds to boot up by executing six cycles.

Each cube only ever considers its neighbors: any of the 26 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3, its neighbors include the cube at x=2,y=2,z=2, the cube at x=0,y=2,z=3, and so on.

During a cycle, all cubes simultaneously change their state according to the following rules:

If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
The engineers responsible for this experimental energy source would like you to simulate the pocket dimension and determine what the configuration of cubes should be at the end of the six-cycle boot process.

For example, consider the following initial state:

.#.
..#
###

Even though the pocket dimension is 3-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1 region of the 3-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z coordinate (and the frame of view follows the active cells in each cycle):

Before any cycles:

z=0
.#.
..#
###


After 1 cycle:

z=-1
#..
..#
.#.

z=0
#.#
.##
.#.

z=1
#..
..#
.#.


After 2 cycles:

z=-2
.....
.....
..#..
.....
.....

z=-1
..#..
.#..#
....#
.#...
.....

z=0
##...
##...
#....
....#
.###.

z=1
..#..
.#..#
....#
.#...
.....

z=2
.....
.....
..#..
.....
.....


After 3 cycles:

z=-2
.......
.......
..##...
..###..
.......
.......
.......

z=-1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=0
...#...
.......
#......
.......
.....##
.##.#..
...#...

z=1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=2
.......
.......
..##...
..###..
.......
.......
.......

After the full six-cycle boot process completes, 112 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles. How many cubes are left in the active state after the sixth cycle?
"""
  defmodule ThreeGrid do
    defstruct [:grid, :x_range, :y_range, :z_range]

    def new, do: %__MODULE__{grid: %{}, x_range: 0..0, y_range: 0..0, z_range: 0..0}

    def value(grid, coordinate, default \\ nil) do
      Map.get(grid.grid, coordinate, default)
    end

    def coordinate_stream(grid, {xoff,yoff,zoff} \\ {1, 1, 1}) do
      Stream.flat_map(range(grid.x_range, xoff), fn x ->
        Stream.flat_map(range(grid.y_range, yoff), fn y ->
          Stream.flat_map(range(grid.z_range, zoff), fn z ->
            [{x, y, z}]
          end)
        end)
      end)
    end

    def size(tg) do
      map_size(tg.grid)
    end

    defp range(min..max, offset) do
      (min-offset)..(max+offset)
    end
  end

  defimpl Collectable, for: ThreeGrid do
    def into(original) do
      collector_fun = fn
        grid, {:cont, {{x, y, z} = coordinate, value}} ->
          new_grid = Map.put(grid.grid, coordinate, value)
          new_x = new_range(grid.x_range, x)
          new_y = new_range(grid.y_range, y)
          new_z = new_range(grid.z_range, z)

          %{grid | grid: new_grid, x_range: new_x, y_range: new_y, z_range: new_z }

        grid, :done -> grid
        ____, :halt -> :ok
      end

      {original, collector_fun}
    end

    defp new_range(old_min..old_max = old_range, value) do
      cond do
        value < old_min -> value..old_max
        value > old_max -> old_min..value
        true -> old_range
      end
    end
  end

  defimpl Enumerable, for: ThreeGrid do
    def reduce(tg, condition, fun) do
      Enumerable.reduce(tg.grid, condition, fun)
    end

    def count(tg) do
      map_size(tg.grid)
    end

    def member?(tg, coord) do
      Map.has_key?(tg, coord)
    end
  end

  defmodule PocketDimension do
    defstruct [:grid]

    def parse(starting_grid) do
      %__MODULE__{grid: parse_grid(starting_grid)}
    end

    def cube_active?(pd, coordinate) do
      ThreeGrid.value(pd.grid, coordinate, false)
    end

    def total_active_cubes(pd) do
      ThreeGrid.size(pd.grid)
    end

    def cycle(pd) do
      new_grid =
        update_active_cubes(pd.grid)
        |> update_inactive_cubes(pd)

      %__MODULE__{grid: new_grid}
    end

    defp update_active_cubes(tg) do
      tg
      |> Enum.map(fn {coordinate, true} ->
        active_around = active_neighbours(tg, coordinate)
        new_status = if active_around in 2..3, do: true, else: false

        {coordinate, new_status}
      end)
      |> Enum.filter(fn {_, status} -> status end)
      |> Enum.into(ThreeGrid.new)
    end

    defp update_inactive_cubes(destination, pd) do
      pd.grid
      |> ThreeGrid.coordinate_stream
      |> Enum.filter(fn coordinate ->
        cond do
          cube_active?(pd, coordinate) -> false
          active_neighbours(pd.grid, coordinate) == 3 -> true
          true -> false
        end
      end)
      |> Enum.map(fn coord -> {coord, true} end)
      |> Enum.into(destination)
    end

    defp parse_grid(grid) do
      grid
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.flat_map(fn {row, y} ->
        row
        |> String.graphemes
        |> Enum.with_index
        |> Enum.map(fn
          {"#", x} -> {{x, y, 0}, true}
          _ -> nil
        end)
        |> Enum.filter(&is_tuple/1)
      end)
      |> Enum.into(ThreeGrid.new)
    end

    defp active_neighbours(three_grid, coordinate) do
      coordinate
      |> neighbours
      |> Enum.map(&ThreeGrid.value(three_grid, &1))
      |> Enum.filter(&(&1))
      |> length
    end

    defp neighbours({x, y, z}) do
      [
        {x+1, y, z},
        {x+1, y+1, z},
        {x+1, y-1, z},
        # {x, y, z},
        {x, y+1, z},
        {x, y-1, z},
        {x-1, y, z},
        {x-1, y+1, z},
        {x-1, y-1, z},

        {x+1, y, z+1},
        {x+1, y+1, z+1},
        {x+1, y-1, z+1},
        {x, y, z+1},
        {x, y+1, z+1},
        {x, y-1, z+1},
        {x-1, y, z+1},
        {x-1, y+1, z+1},
        {x-1, y-1, z+1},

        {x+1, y, z-1},
        {x+1, y+1, z-1},
        {x+1, y-1, z-1},
        {x, y, z-1},
        {x, y+1, z-1},
        {x, y-1, z-1},
        {x-1, y, z-1},
        {x-1, y+1, z-1},
        {x-1, y-1, z-1}
      ]
    end
  end
end
