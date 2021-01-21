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
    display_ids = fn arrangement ->
      arrangement |> Enum.map(&Access.get(&1, :id)) |> Enum.map(&String.to_integer/1)
    end
    tiles = @test |> tilize() |> Enum.map(&parse_tile/1)

    assert display_ids.(arrange(tiles)) == [
      1171, 2473, 3079,
      2311, 1427, 1489,
      2971, 2729, 1951
    ]
  end

  test "extracting image" do
    expected = """
    .####...#####..#...###..
    #####..#..#.#.####..#.#.
    .#.#...#.###...#.##.##..
    #.#.##.###.#.##.##.#####
    ..##.###.####..#.####.##
    ...#.#..##.##...#..#..##
    #.##.#..#.#..#..##.#.#..
    .###.##.....#...###.#...
    #.####.#.#....##.#..#.#.
    ##...#..#....#..#...####
    ..#.##...###..#.#####..#
    ....#.##.#.#####....#...
    ..##.##.###.....#.##..#.
    #...#...###..####....##.
    .#.##...#.##.#.#.###...#
    #.###.#..####...##..#...
    #.###...#.##...#.######.
    .###.###.#######..#####.
    ..##.#..#..#.#######.###
    #.#..##.########..#..##.
    #.#####..#.#...##..#....
    #....##..#.#########..##
    #...#.....#..##...###.##
    #..###....##.#...##.##.#
    """ |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)

    tiles = @test |> tilize() |> Enum.map(&parse_tile/1)
    image = tiles |> arrange |> image

    # compare_images(expected, rotate_until_monsters(image))
    assert rotate_until_monsters(image) == expected
  end

  def compare_images(expected, actual) do
    result =
      Enum.zip([expected, actual])
      |> Enum.map(fn {ex, ac} ->
        if ex == ac do
          IO.puts Enum.join(ex, "")
          IO.puts "---"
          true
        else
          IO.puts Enum.join(ex, "")
          IO.puts Enum.join(ac, "")
          IO.puts "---"
          false
        end
      end)
      |> Enum.all?

    assert result
  end

  test "small image" do
    arrangement = [
      %{body: ["xxxx", "x11x", "x12x", "xxxx"]},
      %{body: ["xxxx", "x21x", "x22x", "xxxx"]},
      %{body: ["xxxx", "x31x", "x32x", "xxxx"]},
      %{body: ["xxxx", "x41x", "x42x", "xxxx"]},
      %{body: ["xxxx", "x51x", "x52x", "xxxx"]},
      %{body: ["xxxx", "x61x", "x62x", "xxxx"]},
      %{body: ["xxxx", "x71x", "x72x", "xxxx"]},
      %{body: ["xxxx", "x81x", "x82x", "xxxx"]},
      %{body: ["xxxx", "x91x", "x92x", "xxxx"]},
    ]

    assert image(arrangement) == [
      ~w(1 1 2 1 3 1),
      ~w(1 2 2 2 3 2),
      ~w(6 1 5 1 4 1),
      ~w(6 2 5 2 4 2),
      ~w(7 1 8 1 9 1),
      ~w(7 2 8 2 9 2)
    ]
  end

  test "count_monsters" do
    image = [
      "...................#....................#.",
      ".#....##....##....###.#....##....##....###",
      "..#..#..#..#..#..#.....#..#..#..#..#..#...",
      "...................#....................#.",
      ".#....##....##....###.#....##....##....###",
      "..#..#..#..#..#..#.....#..#..#..#..#..#...",
    ] |> Enum.map(&String.codepoints/1)

    assert count_monsters(image) == 4
  end

  test "roughness" do
    assert @test |> tilize() |> Enum.map(&parse_tile/1) |> arrange() |> roughness() == 273
  end

  test "rough_waters" do
    assert rough_waters([["#", ".", "#"], [".", "#", "."], [".", "#", "."]]) == MapSet.new([{0, 0}, {0, 2}, {1, 1}, {2, 1}])
  end

  test "part 2" do
    result =
      Input.strings(20)
      |> tilize
      |> Enum.map(&parse_tile/1)
      |> arrange()
      |> roughness()

    # 1855 too high -- none found :(
    IO.puts("Part 2: #{result}")
    IO.puts("")
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
