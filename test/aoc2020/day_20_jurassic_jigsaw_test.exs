defmodule Aoc2020.Day20JurassicJigsawTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day20JurassicJigsaw

  @test """
  Tile 2311:
  ..##.#..#.
  ##..#.....
  #...##..#.
  ####.#...#
  ##.##.###.
  ##...#.###
  .#.#.#..##
  ..#....#..
  ###...#.#.
  ..###..###

  Tile 1951:
  #.##...##.
  #.####...#
  .....#..##
  #...######
  .##.#....#
  .###.#####
  ###.##.##.
  .###....#.
  ..#.#..#.#
  #...##.#..

  Tile 1171:
  ####...##.
  #..##.#..#
  ##.#..#.#.
  .###.####.
  ..###.####
  .##....##.
  .#...####.
  #.##.####.
  ####..#...
  .....##...

  Tile 1427:
  ###.##.#..
  .#..#.##..
  .#.##.#..#
  #.#.#.##.#
  ....#...##
  ...##..##.
  ...#.#####
  .#.####.#.
  ..#..###.#
  ..##.#..#.

  Tile 1489:
  ##.#.#....
  ..##...#..
  .##..##...
  ..#...#...
  #####...#.
  #..#.#.#.#
  ...#.#.#..
  ##.#...##.
  ..##.##.##
  ###.##.#..

  Tile 2473:
  #....####.
  #..#.##...
  #.##..#...
  ######.#.#
  .#...#.#.#
  .#########
  .###.#..#.
  ########.#
  ##...##.#.
  ..###.#.#.

  Tile 2971:
  ..#.#....#
  #...###...
  #.#.###...
  ##.##..#..
  .#####..##
  .#..####.#
  #..#.#..#.
  ..####.###
  ..#.#.###.
  ...#.#.#.#

  Tile 2729:
  ...#.#.#.#
  ####.#....
  ..#.#.....
  ....#..#.#
  .##..##.#.
  .#.####...
  ####.#.#..
  ##.####...
  ##..#.##..
  #.##...##.

  Tile 3079:
  #.#.#####.
  .#..######
  ..#.......
  ######....
  ####.#..#.
  .#...#.##.
  #.#####.##
  ..#.###...
  ..#.......
  ..#.###...
  """ |> String.split("\n")

  test "parsing" do
    assert parse_tile(hd(tilize(@test))) == %{
      id: "2311",
      sides: [
        "..##.#..#.",
        "..###..###",
        ".#####..#.",
        "...#.##..#"
      ],
      body: [
        "..##.#..#.",
        "##..#.....",
        "#...##..#.",
        "####.#...#",
        "##.##.###.",
        "##...#.###",
        ".#.#.#..##",
        "..#....#..",
        "###...#.#.",
        "..###..###"
      ]
    }
  end

 test "solve" do
   assert edges(@test |> tilize() |> Enum.map(&parse_tile/1)) |> product_of_corner_ids == 20899048083289
 end

 test "part 1" do
   result =
     Input.strings(20)
     |> tilize
     |> Enum.map(&parse_tile/1)
     |> edges
     |> product_of_corner_ids

   IO.puts("Part 1: #{result}")
   IO.puts("")
 end

 test "rotate" do
   tile = @test |> tilize |> hd |> parse_tile |> Map.put(:rotation, :none)
   assert rotate(:none, tile, %{}) == %{
     body: ["..##.#..#.", "##..#.....", "#...##..#.", "####.#...#", "##.##.###.",
            "##...#.###", ".#.#.#..##", "..#....#..", "###...#.#.", "..###..###"],
     id: "2311",
     sides: ["..##.#..#.", "..###..###", ".#####..#.", "...#.##..#"]
   }

   tile = Map.put(tile, :rotation, :flip_vertical)
   assert rotate(:none, tile, %{}) == %{
     body: ["..###..###", "###...#.#.", "..#....#..", ".#.#.#..##", "##...#.###",
            "##.##.###.", "####.#...#", "#...##..#.", "##..#.....", "..##.#..#."],
     id: "2311",
     sides: ["..###..###", "..##.#..#.", ".#..#####.", "#..##.#..."]
   }

   tiles = @test |> tilize() |> Enum.map(&parse_tile/1)
   edges = edges(tiles)
   corner = Enum.find(edges |> Map.values |> List.flatten, fn %{id: id} -> id == "1951" end)

   rotate(:top_left, corner, edges)
 end

 test "direction" do
   # example:
   # 1 2 3  :right :right :bottom
   # 6 5 4  :bottom  :left  :left
   # 7 8 9  :right :right

   assert direction(1, 3) == :right
   assert direction(2, 3) == :right
   assert direction(3, 3) == :bottom
   assert direction(4, 3) == :left
   assert direction(5, 3) == :left
   assert direction(6, 3) == :bottom
   assert direction(7, 3) == :right
   assert direction(8, 3) == :right
 end

 test "arranging tiles" do
   assert arrange(@test |> tilize() |> Enum.map(&parse_tile/1)) |> Enum.map(&Access.get(&1, :id)) |> Enum.map(&String.to_integer/1) == [
     1171, 2473, 3079,
     2311, 1427, 1489,
     2971, 2729, 1951
   ]
 end

  def tilize(lines) do
    lines
    |> Enum.chunk_by(&(String.length(&1) == 0))
    |> Enum.filter(fn
      [""] -> false
      ____ -> true
    end)
  end
end
