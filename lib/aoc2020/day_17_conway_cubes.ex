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

--- Part Two ---

For some reason, your simulated results don't match what the experimental energy source engineers expected. Apparently, the pocket dimension actually has four spatial dimensions, not three.

The pocket dimension contains an infinite 4-dimensional grid. At every integer 4-dimensional coordinate (x,y,z,w), there exists a single cube (really, a hypercube) which is still either active or inactive.

Each cube only ever considers its neighbors: any of the 80 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3,w=4, its neighbors include the cube at x=2,y=2,z=3,w=3, the cube at x=0,y=2,z=3,w=4, and so on.

The initial state of the pocket dimension still consists of a small flat region of cubes. Furthermore, the same rules for cycle updating still apply: during each cycle, consider the number of active neighbors of each cube.

For example, consider the same initial state as in the example above. Even though the pocket dimension is 4-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1x1 region of the 4-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z and w coordinate:

Before any cycles:

z=0, w=0
.#.
..#
###


After 1 cycle:

z=-1, w=-1
#..
..#
.#.

z=0, w=-1
#..
..#
.#.

z=1, w=-1
#..
..#
.#.

z=-1, w=0
#..
..#
.#.

z=0, w=0
#.#
.##
.#.

z=1, w=0
#..
..#
.#.

z=-1, w=1
#..
..#
.#.

z=0, w=1
#..
..#
.#.

z=1, w=1
#..
..#
.#.


After 2 cycles:

z=-2, w=-2
.....
.....
..#..
.....
.....

z=-1, w=-2
.....
.....
.....
.....
.....

z=0, w=-2
###..
##.##
#...#
.#..#
.###.

z=1, w=-2
.....
.....
.....
.....
.....

z=2, w=-2
.....
.....
..#..
.....
.....

z=-2, w=-1
.....
.....
.....
.....
.....

z=-1, w=-1
.....
.....
.....
.....
.....

z=0, w=-1
.....
.....
.....
.....
.....

z=1, w=-1
.....
.....
.....
.....
.....

z=2, w=-1
.....
.....
.....
.....
.....

z=-2, w=0
###..
##.##
#...#
.#..#
.###.

z=-1, w=0
.....
.....
.....
.....
.....

z=0, w=0
.....
.....
.....
.....
.....

z=1, w=0
.....
.....
.....
.....
.....

z=2, w=0
###..
##.##
#...#
.#..#
.###.

z=-2, w=1
.....
.....
.....
.....
.....

z=-1, w=1
.....
.....
.....
.....
.....

z=0, w=1
.....
.....
.....
.....
.....

z=1, w=1
.....
.....
.....
.....
.....

z=2, w=1
.....
.....
.....
.....
.....

z=-2, w=2
.....
.....
..#..
.....
.....

z=-1, w=2
.....
.....
.....
.....
.....

z=0, w=2
###..
##.##
#...#
.#..#
.###.

z=1, w=2
.....
.....
.....
.....
.....

z=2, w=2
.....
.....
..#..
.....
.....
After the full six-cycle boot process completes, 848 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles in a 4-dimensional space. How many cubes are left in the active state after the sixth cycle?
"""
  defmodule ThreeGrid do
    defstruct [:grid, :dimension, :ranges]

    def new(dimension) do
      default_ranges = Enum.map(1..dimension, fn _ -> 0..0 end)

      %__MODULE__{grid: %{}, dimension: dimension, ranges: default_ranges}
    end

    def value(grid, coordinate, default \\ nil) do
      Map.get(grid.grid, coordinate, default)
    end

    def coordinate_stream(grid, offset \\ 1) do
      do_coordinate_stream(grid.ranges, offset, [])
    end

    def size(tg) do
      map_size(tg.grid)
    end

    defp do_coordinate_stream([], _offset, values) do
      [Enum.reverse(values)]
    end

    defp do_coordinate_stream([r | ranges], offset, values) do
      Stream.flat_map(range(r, offset), fn x ->
        do_coordinate_stream(ranges, offset, [x | values])
      end)
    end

    defp range(min..max, offset) do
      (min-offset)..(max+offset)
    end
  end

  defimpl Collectable, for: ThreeGrid do
    def into(original) do
      collector_fun = fn
        grid, {:cont, {coordinate, value}} ->
          new_grid = Map.put(grid.grid, coordinate, value)
          new_ranges =
            grid.ranges
            |> Enum.zip(coordinate)
            |> Enum.map(fn {range, val} -> new_range(range, val) end)

          %{grid | grid: new_grid, ranges: new_ranges}

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
    defstruct [:grid, :dimensions]

    def parse(starting_grid, dimensions \\ 3) do
      coordinate_fun = fn x, y ->
        [x, y] ++ Enum.map(1..(dimensions - 2), fn _ -> 0 end)
      end
      grid = ThreeGrid.new(dimensions)

      %__MODULE__{grid: parse_grid(starting_grid, grid, coordinate_fun), dimensions: dimensions}
    end

    def cube_active?(pd, coordinate) do
      ThreeGrid.value(pd.grid, coordinate, false)
    end

    def total_active_cubes(pd) do
      ThreeGrid.size(pd.grid)
    end

    def cycle(pd) do
      new_grid =
        ThreeGrid.new(pd.dimensions)
        |> update_active_cubes(pd)
        |> update_inactive_cubes(pd)

      %{pd | grid: new_grid}
    end

    defp update_active_cubes(into, pd) do
      pd.grid
      |> Enum.map(fn {coordinate, true} ->
        active_around = active_neighbours(pd, coordinate)
        new_status = if active_around in 2..3, do: true, else: false

        {coordinate, new_status}
      end)
      |> Enum.filter(fn {_, status} -> status end)
      |> Enum.into(into)
    end

    defp update_inactive_cubes(into, pd) do
      pd.grid
      |> ThreeGrid.coordinate_stream
      |> Enum.filter(fn coordinate ->
        cond do
          cube_active?(pd, coordinate) -> false
          active_neighbours(pd, coordinate) == 3 -> true
          true -> false
        end
      end)
      |> Enum.map(fn coord -> {coord, true} end)
      |> Enum.into(into)
    end

    defp parse_grid(grid, into, initial_coordinate) do
      grid
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.flat_map(fn {row, y} ->
        row
        |> String.graphemes
        |> Enum.with_index
        |> Enum.map(fn
          {"#", x} -> {initial_coordinate.(x, y), true}
          _ -> nil
        end)
        |> Enum.filter(&is_tuple/1)
      end)
      |> Enum.into(into)
    end

    defp active_neighbours(pd, coordinate) do
      coordinate
      |> neighbours(pd.dimensions)
      |> Enum.map(&ThreeGrid.value(pd.grid, &1))
      |> Enum.filter(&(&1))
      |> length
    end

    def neighbours(coordinate, dimension) do
      translations(dimension)
      |> Enum.map(fn translation ->
        translation
        |> Enum.zip(coordinate)
        |> Enum.map(fn {t, xi} -> t + xi end)
      end)
    end

    defp translations(dimension) do
      do_translations(dimension, dimension - 1, [[-1], [0], [1]])
    end

    defp do_translations(_n, 0, translations) do
      translations
      |> Stream.filter(fn t -> not Enum.all?(t, &(&1 == 0)) end)
      |> Enum.map(&Enum.reverse/1)
    end

    defp do_translations(n, left, translations) do
      values = [-1, 0, 1]
      new_translations = Enum.flat_map(translations, fn translated ->
        Enum.map(values, fn v ->
          [v | translated]
        end)
      end)

      do_translations(n, left - 1, new_translations)
    end
  end
end
