defmodule Aoc2020.Day03TobogganTrajectory do
  @moduledoc """
--- Day 3: Toboggan Trajectory ---
With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#

These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

..##.........##.........##.........##.........##.........##.......  --->
#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........#.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...##....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

..##.........##.........##.........##.........##.........##.......  --->
#..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........X.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...#X....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

In this example, traversing the map using this slope would cause you to encounter 7 trees.

Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
"""
  defmodule TreeGrid do
    defstruct [:width, :height, :trees]

    def new(text) do
      lines = String.split(text, "\n", trim: true)
      height = length(lines)
      width = String.length(hd(lines))
      trees = parse(lines)

      %__MODULE__{trees: trees, width: width, height: height}
    end

    def tree?(tree_grid, coordinate) do
      MapSet.member?(tree_grid.trees, coordinate)
    end

    def tree_count(tree_grid) do
      MapSet.size(tree_grid.trees)
    end

    defp parse(lines) do
      lines
      |> Enum.with_index(1)
      |> Enum.flat_map(&parse_row/1)
      |> Enum.into(MapSet.new)
    end

    defp parse_row({line, row}) when is_integer(row) do
      line
      |> String.codepoints
      |> Enum.with_index(1)
      |> Enum.map(fn
        {".", _} -> nil
        {"#", col} -> {row, col}
      end)
      |> Enum.filter(&(&1))
    end
  end

  def trees_along_descent(trees, start, descent) do
    tree_grid = TreeGrid.new(trees)

    descent_coordinates(start, {tree_grid.height, tree_grid.width}, descent)
    |> Enum.filter(&TreeGrid.tree?(tree_grid, &1))
    |> length
  end

  defp descent_coordinates(start, maxes, slope) do
    do_descent_coordinates(start, maxes, slope, [])
  end

  defp do_descent_coordinates({row, _}, {max_row, _}, _, coordinates) when row > max_row do
    coordinates
  end

  defp do_descent_coordinates({row, col}, {_, max_col} = maxes, {dr, dc} = slope, coordinates) do
    scaled_col = if rem(col, max_col) == 0 do
      max_col
    else
      rem(col, max_col)
    end

    do_descent_coordinates({row + dr, col + dc}, maxes, slope, [{row, scaled_col} | coordinates])
  end
end
