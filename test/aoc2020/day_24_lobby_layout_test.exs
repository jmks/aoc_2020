defmodule Aoc2020.Day24LobbyLayoutTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day24LobbyLayout
  alias Aoc2020.Day24LobbyLayout.HexagonalGrid

  @test """
  sesenwnenenewseeswwswswwnenewsewsw
  neeenesenwnwwswnenewnwwsewnenwseswesw
  seswneswswsenwwnwse
  nwnwneseeswswnenewneswwnewseswneseene
  swweswneswnenwsewnwneneseenw
  eesenwseswswnenwswnwnwsewwnwsene
  sewnenenenesenwsewnenwwwse
  wenwwweseeeweswwwnwwe
  wsweesenenewnwwnwsenewsenwwsesesenwne
  neeswseenwwswnwswswnw
  nenwswwsewswnenenewsenwsenwnesesenew
  enewnwewneswsewnwswenweswnenwsenwsw
  sweneswneswneneenwnewenewwneswswnese
  swwesenesewenwneswnwwneseswwne
  enesenwswwswneneswsenwnewswseenwsese
  wnwnesenesenenwwnenwsewesewsesesew
  nenewswnwewswnenesenwnesewesw
  eneswnwswnwsenenwnwnwwseeswneewsenese
  neswnwewnwnwseenwseesewsenwsweewe
  wseweeenwnesenwwwswnew
  """ |> String.split("\n", trim: true)

  test "parse path" do
    assert HexagonalGrid.parse_path("sesenwnenenewseeswwswswwnenewsewsw") == ~w(se se nw ne ne ne w se e sw w sw sw w ne ne w se w sw)
  end

  test "example" do
    outer_grid = HexagonalGrid.new

    assert Enum.reduce(@test, outer_grid, fn tile, grid -> HexagonalGrid.flip(grid, tile) end) |> HexagonalGrid.black_tiles() == 10
  end

  test "part 1" do
    result =
      Input.strings(24)
      |> Enum.reduce(HexagonalGrid.new, fn tile, grid ->
        HexagonalGrid.flip(grid, tile)
      end)
      |> HexagonalGrid.black_tiles

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end
end
