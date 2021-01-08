defmodule Aoc2020.Day24LobbyLayout do
  @moduledoc """
  --- Day 24: Lobby Layout ---
  Your raft makes it to the tropical island; it turns out that the small crab was an excellent navigator. You make your way to the resort.

  As you enter the lobby, you discover a small problem: the floor is being renovated. You can't even reach the check-in desk until they've finished installing the new tile floor.

  The tiles are all hexagonal; they need to be arranged in a hex grid with a very specific color pattern. Not in the mood to wait, you offer to help figure out the pattern.

  The tiles are all white on one side and black on the other. They start with the white side facing up. The lobby is large enough to fit whatever pattern might need to appear there.

  A member of the renovation crew gives you a list of the tiles that need to be flipped over (your puzzle input). Each line in the list identifies a single tile that needs to be flipped by giving a series of steps starting from a reference tile in the very center of the room. (Every line starts from the same reference tile.)

  Because the tiles are hexagonal, every tile has six neighbors: east, southeast, southwest, west, northwest, and northeast. These directions are given in your list, respectively, as e, se, sw, w, nw, and ne. A tile is identified by a series of these directions with no delimiters; for example, esenee identifies the tile you land on if you start at the reference tile and then move one tile east, one tile southeast, one tile northeast, and one tile east.

  Each time a tile is identified, it flips from white to black or from black to white. Tiles might be flipped more than once. For example, a line like esew flips a tile immediately adjacent to the reference tile, and a line like nwwswee flips the reference tile itself.

  Here is a larger example:

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

  In the above example, 10 tiles are flipped once (to black), and 5 more are flipped twice (to black, then back to white). After all of these instructions have been followed, a total of 10 tiles are black.

  Go through the renovation crew's list and determine which tiles they need to flip. After all of the instructions have been followed, how many tiles are left with the black side up?

  --- Part Two ---

  The tile floor in the lobby is meant to be a living art exhibit. Every day, the tiles are all flipped according to the following rules:

  Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
  Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
  Here, tiles immediately adjacent means the six tiles directly touching the tile in question.

  The rules are applied simultaneously to every tile; put another way, it is first determined which tiles need to be flipped, then they are all flipped at the same time.

  In the above example, the number of black tiles that are facing up after the given number of days has passed is as follows:

  Day 1: 15
  Day 2: 12
  Day 3: 25
  Day 4: 14
  Day 5: 23
  Day 6: 28
  Day 7: 41
  Day 8: 37
  Day 9: 49
  Day 10: 37

  Day 20: 132
  Day 30: 259
  Day 40: 406
  Day 50: 566
  Day 60: 788
  Day 70: 1106
  Day 80: 1373
  Day 90: 1844
  Day 100: 2208

  After executing this process a total of 100 times, there would be 2208 black tiles facing up.

  How many tiles will be black after 100 days?
  """
  defmodule HexagonalGrid do
    defstruct [:tiles]

    def new do
      %__MODULE__{tiles: %{}}
    end

    def flip(grid, path) do
      tile_coordinate = travel(path, {0, 0})
      colour = Map.get(grid.tiles, tile_coordinate, :white) |> flip

      new_tiles =
        case colour do
          :white -> Map.delete(grid.tiles, tile_coordinate)
          :black -> Map.put(grid.tiles, tile_coordinate, :black)
        end

      %{grid | tiles: new_tiles}
    end

    def black_tiles(grid) do
      map_size(grid.tiles)
    end

    def parse_path(path) do
      do_parse_path(path, [])
    end

    def next_day(grid) do
      new_tiles =
        grid.tiles
        |> Enum.flat_map(fn {tile, :black} ->
          black = black_tiles_around(tile, grid.tiles)
          new_colour = if black == 0 or black > 2, do: :white, else: :black

          adjacent_colours = Enum.map(adjacent(tile), fn tile ->
            colour = if black_tiles_around(tile, grid.tiles) == 2, do: :black, else: :white

            {tile, colour}
          end)

          [{tile, new_colour} | adjacent_colours]
        end)
        |> Enum.filter(fn
          {_, :black} -> true
          ___________ -> false
        end)
        |> Enum.into(%{})

      %{grid | tiles: new_tiles}
    end

    defp adjacent(coordinate) do
      ~w(e se ne w sw nw) |> Enum.map(&move(coordinate, &1))
    end

    defp move({q, r}, direction) do
      {dq, dr} = offsets(direction)

      {q + dq, r + dr}
    end

    defp black_tiles_around(coordinate, tiles) do
      coordinate
      |> adjacent
      |> Enum.map(&(Map.get(tiles, &1)))
      |> Enum.filter(&(&1 == :black))
      |> length
    end

    defp travel(path, coordinate) do
      path
      |> parse_path
      |> Enum.reduce(coordinate, &move(&2, &1))
    end

    defp offsets("e"), do: {1, 0}
    defp offsets("se"), do: {0, 1}
    defp offsets("ne"), do: {1, -1}
    defp offsets("w"), do: {-1, 0}
    defp offsets("sw"), do: {-1, 1}
    defp offsets("nw"), do: {0, -1}

    defp flip(:white), do: :black
    defp flip(:black), do: :white

    defp do_parse_path("", path), do: Enum.reverse(path)
    defp do_parse_path("e" <> rest, path), do: do_parse_path(rest, ["e" | path])
    defp do_parse_path("se" <> rest, path), do: do_parse_path(rest, ["se" | path])
    defp do_parse_path("sw" <> rest, path), do: do_parse_path(rest, ["sw" | path])
    defp do_parse_path("w" <> rest, path), do: do_parse_path(rest, ["w" | path])
    defp do_parse_path("nw" <> rest, path), do: do_parse_path(rest, ["nw" | path])
    defp do_parse_path("ne" <> rest, path), do: do_parse_path(rest, ["ne" | path])
  end
end
