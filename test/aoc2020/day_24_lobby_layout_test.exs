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
    assert flip_tiles(HexagonalGrid.new, @test) |> HexagonalGrid.black_tiles() == 10
  end

  test "part 1" do
    result =
      flip_tiles(HexagonalGrid.new, Input.strings(24))
      |> HexagonalGrid.black_tiles

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end

  test "living tiles" do
    zero = flip_tiles(HexagonalGrid.new, @test)

    assert flip_days(zero, 1) |> HexagonalGrid.black_tiles == 15
    assert flip_days(zero, 2) |> HexagonalGrid.black_tiles == 12
    assert flip_days(zero, 3) |> HexagonalGrid.black_tiles == 25
    assert flip_days(zero, 20) |> HexagonalGrid.black_tiles == 132
    assert flip_days(zero, 100) |> HexagonalGrid.black_tiles == 2208
  end

  test "part 2" do
    result =
      flip_tiles(HexagonalGrid.new, Input.strings(24))
      |> flip_days(100)
      |> HexagonalGrid.black_tiles

    IO.puts("")
    IO.puts("Part 2: #{result}")
  end

  defp flip_tiles(grid, tiles) do
    Enum.reduce(tiles, grid, fn tile, grid ->
      HexagonalGrid.flip(grid, tile)
    end)
  end

  defp flip_days(grid, 0), do: grid
  defp flip_days(grid, days) do
    grid
    |> HexagonalGrid.next_day
    |> flip_days(days - 1)
  end
end
