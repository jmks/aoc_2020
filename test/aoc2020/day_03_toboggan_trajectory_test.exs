defmodule Aoc2020.Day03TobogganTrajectoryTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day03TobogganTrajectory
  alias Aoc2020.Day03TobogganTrajectory.TreeGrid

  @test_grid """
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
  """

  @part1 """
  .#.#....###..#.#..............#
  #......#####..##.##.#.......#.#
  .###.....#..#.#..#..#.#......#.
  .........##.#.....#.#..........
  ........##....#.......#.#..#..#
  #.#..####...#.....#.#.#...#....
  #....#...#.........#.....#..#.#
  .#..........#..#.............#.
  ...##..##..#...####.#.#.#.#....
  .#...####............##....#...
  ..##.....#.#......#......#.#.#.
  ..##......#..##.....#.#.....#.#
  ..#...#....#.#.........##......
  #..##..##..#..##....#....##.#.#
  ..###.#....#.#.#...#......#.#.#
  ....#...#...#.........#.....##.
  .#..#.#..........#.##.....#.#..
  .#...#...###..#..#..####.#...#.
  ##..............#..#.#...###..#
  .#..#.#.#...#..#...#..#........
  """

  test "parses a grid of trees" do
    tree_grid = TreeGrid.new(@test_grid)

    assert TreeGrid.tree?(tree_grid, {1, 3})
    assert TreeGrid.tree?(tree_grid, {1, 4})
    assert TreeGrid.tree?(tree_grid, {2, 1})
    assert TreeGrid.tree?(tree_grid, {3, 7})
    refute TreeGrid.tree?(tree_grid, {2, 4})
    assert TreeGrid.tree?(tree_grid, {11, 2})

    assert tree_grid.width == 11
    assert tree_grid.height == 11

    assert TreeGrid.tree_count(tree_grid) == 37
  end

  test "count trees along a descent" do
    assert trees_along_descent(@test_grid, {1, 1}, {1, 3}) == 7
    assert trees_along_descent(@part1, {1, 1}, {1, 3}) == 8
  end

  test "solve part 1" do
    trees_encountered = trees_along_descent(Input.raw(3), {1, 1}, {1, 3})

    IO.puts("")
    IO.puts("Part 1: #{trees_encountered}")
  end
end
