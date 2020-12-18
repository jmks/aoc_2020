defmodule Aoc2020.Day17ConwayCubesTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day17ConwayCubes
  alias Aoc2020.Day17ConwayCubes.{PocketDimension, ThreeGrid}

  @test """
  .#.
  ..#
  ###
  """

  test "parsing" do
    pd = PocketDimension.parse(@test)

    refute PocketDimension.cube_active?(pd, {0, 0, 0})
    assert PocketDimension.cube_active?(pd, {1, 0, 0})
    refute PocketDimension.cube_active?(pd, {1, 1, 0})
    assert PocketDimension.cube_active?(pd, {1, 2, 0})
    assert PocketDimension.cube_active?(pd, {0, 2, 0})
    assert PocketDimension.cube_active?(pd, {1, 2, 0})
    assert PocketDimension.cube_active?(pd, {2, 2, 0})
  end

  test "cycles" do
    pd = PocketDimension.parse(@test)
    assert PocketDimension.total_active_cubes(pd) == 5

    pd = PocketDimension.cycle(pd)
    assert PocketDimension.total_active_cubes(pd) == 11

    pd = PocketDimension.cycle(pd)
    assert PocketDimension.total_active_cubes(pd) == 21

    pd = PocketDimension.cycle(pd)
    assert PocketDimension.total_active_cubes(pd) == 38

    pd =
      pd
      |> PocketDimension.cycle
      |> PocketDimension.cycle
      |> PocketDimension.cycle

    assert PocketDimension.total_active_cubes(pd) == 112
  end

  test "ThreeGrid.coordinate_stream" do
    grid = Enum.into([{{0,0,0}, true}], ThreeGrid.new)
    coords = Enum.into(ThreeGrid.coordinate_stream(grid), [])

    assert length(coords) == 27
  end

  test "part 1" do
    result = Enum.reduce(1..6, PocketDimension.parse(Input.raw(17)), fn _, pd ->
      PocketDimension.cycle(pd)
    end)
    |> PocketDimension.total_active_cubes

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end
end
