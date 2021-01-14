defmodule Aoc2020.Day20JurassicJigsaw do
  @moduledoc """
--- Day 20: Jurassic Jigsaw ---
The high-speed train leaves the forest and quickly carries you south. You can even see a desert in the distance! Since you have some spare time, you might as well see if there was anything interesting in the image the Mythical Information Bureau satellite captured.

After decoding the satellite messages, you discover that the data actually contains many small images created by the satellite's camera array. The camera array consists of many cameras; rather than produce a single square image, they produce many smaller square image tiles that need to be reassembled back into a single image.

Each camera in the camera array returns a single monochrome image tile with a random unique ID number. The tiles (your puzzle input) arrived in a random order.

Worse yet, the camera array appears to be malfunctioning: each image tile has been rotated and flipped to a random orientation. Your first task is to reassemble the original image by orienting the tiles so they fit together.

To show how the tiles should be reassembled, each tile's image data includes a border that should line up exactly with its adjacent tiles. All tiles have this border, and the border lines up exactly when the tiles are both oriented correctly. Tiles at the edge of the image also have this border, but the outermost edges won't line up with any other tiles.

For example, suppose you have the following nine tiles:

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
By rotating, flipping, and rearranging them, you can find a square arrangement that causes all adjacent borders to line up:

#...##.#.. ..###..### #.#.#####.
..#.#..#.# ###...#.#. .#..######
.###....#. ..#....#.. ..#.......
###.##.##. .#.#.#..## ######....
.###.##### ##...#.### ####.#..#.
.##.#....# ##.##.###. .#...#.##.
#...###### ####.#...# #.#####.##
.....#..## #...##..#. ..#.###...
#.####...# ##..#..... ..#.......
#.##...##. ..##.#..#. ..#.###...

#.##...##. ..##.#..#. ..#.###...
##..#.##.. ..#..###.# ##.##....#
##.####... .#.####.#. ..#.###..#
####.#.#.. ...#.##### ###.#..###
.#.####... ...##..##. .######.##
.##..##.#. ....#...## #.#.#.#...
....#..#.# #.#.#.##.# #.###.###.
..#.#..... .#.##.#..# #.###.##..
####.#.... .#..#.##.. .######...
...#.#.#.# ###.##.#.. .##...####

...#.#.#.# ###.##.#.. .##...####
..#.#.###. ..##.##.## #..#.##..#
..####.### ##.#...##. .#.#..#.##
#..#.#..#. ...#.#.#.. .####.###.
.#..####.# #..#.#.#.# ####.###..
.#####..## #####...#. .##....##.
##.##..#.. ..#...#... .####...#.
#.#.###... .##..##... .####.##.#
#...###... ..##...#.. ...#..####
..#.#....# ##.#.#.... ...##.....

For reference, the IDs of the above tiles are:

1951    2311    3079
2729    1427    2473
2971    1489    1171

To check that you've assembled the image correctly, multiply the IDs of the four corner tiles together. If you do this with the assembled tiles from the example above, you get 1951 * 3079 * 2971 * 1171 = 20899048083289.

Assemble the tiles into an image. What do you get if you multiply together the IDs of the four corner tiles?
"""
  def parse_tile(lines) do
    [id_line | tile] = lines

    id = id_line |> String.split(" ", parts: 2) |> List.last |> String.trim_trailing(":")

    %{
      id: id,
      sides: sides(tile),
      body: tile
    }
  end

  defp sides(tile_body) do
    top = hd(tile_body)
    bottom = List.last(tile_body)
    left = Enum.map(tile_body, &String.slice(&1, 0, 1)) |> Enum.join("")
    right = Enum.map(tile_body, &String.slice(&1, -1, 1)) |> Enum.join("")

    [top, bottom, left, right]
  end

  def edges(tiles) do
    Enum.reduce(tiles, %{}, fn %{sides: sides} = tile, outer_map ->
      [top, bottom, left, right] = sides

      new_boarders = [
        {top, Map.put(tile, :rotation, :none)},
        {String.reverse(top), Map.put(tile, :rotation, :flip_horizontal)},
        {bottom, Map.put(tile, :rotation, :none)},
        {String.reverse(bottom), Map.put(tile, :rotation, :flip_horizontal)},
        {left, Map.put(tile, :rotation, :none)},
        {String.reverse(left), Map.put(tile, :rotation, :flip_vertical)},
        {right, Map.put(tile, :rotation, :none)},
        {String.reverse(right), Map.put(tile, :rotation, :flip_vertical)}
      ]

      Enum.reduce(new_boarders, outer_map, fn {boarder, info}, map ->
        Map.update(map, boarder, [info], fn infos -> [info | infos] end)
      end)
    end)
  end

  def arrange(tiles) do
    square = length(tiles) |> :math.sqrt |> round
    edges = edges(tiles) # TODO: these ones have the :rotation key
    corner_tile_ids = corners(edges)

    # place tiles to follow this pattern:
    # tiles  align direction
    # 1 2 3  :right :right :bottom
    # 6 5 4  :bottom  :left  :left
    # 7 8 9  :right :right

    some_corner_id = hd(corner_tile_ids)
    some_corner_tile = Enum.find(tiles, fn %{id: id} -> id == some_corner_id end)
    some_corner = Map.get(edges, hd(some_corner_tile[:sides])) |> Enum.find(fn %{id: id} -> id == some_corner_id end)
    top_left = rotate(:top_left, some_corner, edges)

    arrange(1, square, [top_left], edges)
    |> Enum.chunk_every(square)
    |> Enum.with_index
    |> Enum.map(fn {list, index} ->
      if rem(index, 2) do
        list
      else
        Enum.reverse(list)
      end
    end)
    |> List.flatten
  end

  defp arrange(tile, side_length, arrangement, edges)

  defp arrange(_tile, side_length, arrangement, _edges) when length(arrangement) == side_length * side_length do
    Enum.reverse(arrangement)
  end

  defp arrange(tile, side_length, [last | _] = arrangement, edges) do
    tile_edge = direction(tile, side_length)
    side = side(last, tile_edge)
    next_tile =
      Map.get(edges, side)
      |> Enum.find(fn %{id: id} -> id != last[:id] end)
    arranged_tile = align_complementary_side(last, tile_edge, next_tile)

    arrange(tile + 1, side_length, [arranged_tile | arrangement], edges)
  end

  # TODO: this is computing the direction wrong
  def direction(tile, side_tiles) do
    left_or_right = if rem(div(tile, side_tiles), 2) == 0, do: :right, else: :left

    if rem(tile, side_tiles) == 0 do
      :bottom
    else
      left_or_right
    end
  end

  def rotate(rotation, tile, edges)

  def rotate(:none, tile, _) do
    flip(tile)
  end

  def rotate(:top_left, tile, edges) do
    tile
    |> flip()
    |> rotate_until_unique(:left, edges)
    |> rotate_until_unique(:top, edges)
  end

  def align_complementary_side(source_tile, source_edge, destination_tile) do
    complementary_edge = opposite_direction(source_edge)
    side = side(source_tile, source_edge)
    flipped = flip(destination_tile)

    arrange_until_side_matches(side, complementary_edge, flipped)
  end

  defp arrange_until_side_matches(pattern, edge, tile) do
    horizontal = flip(Map.put(tile, :rotation, :flip_horizontal))
    vertical = flip(Map.put(tile, :rotation, :flip_vertical))

    cond do
      side(tile, edge) == pattern ->
        tile
      side(horizontal, edge) == pattern ->
        horizontal
      side(vertical, edge) == pattern ->
        vertical
      true ->
        arrange_until_side_matches(pattern, edge, rotate(tile))
    end
  end

  defp rotate_until_unique(tile, edge, edges) do
    side = side(tile, edge)

    if length(Map.get(edges, side)) == 1 do
      tile
    else
      rotate_until_unique(rotate(tile), edge, edges)
    end
  end

  defp side(%{sides: [top, bottom, left, right]}, side) do
    case side do
      :top -> top
      :bottom -> bottom
      :left -> left
      :right -> right
    end
  end

  defp opposite_direction(:top), do: :bottom
  defp opposite_direction(:left), do: :right
  defp opposite_direction(:right), do: :left
  defp opposite_direction(:bottom), do: :top

  def rotate(%{body: body} = tile) do
    new_body =
      body
      |> Enum.map(&String.codepoints/1)
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.map(&Enum.join(&1, ""))

    %{tile | body: new_body, sides: sides(new_body)}
  end

  defp flip(%{rotation: :none} = tile), do: Map.delete(tile, :rotation)

  defp flip(%{rotation: :flip_horizontal} = tile) do
    new_body = Enum.map(tile.body, &String.reverse/1)

    tile
    |> Map.delete(:rotation)
    |> Map.put(:body, new_body)
    |> Map.put(:sides, sides(new_body))
  end

  defp flip(%{rotation: :flip_vertical} = tile) do
    new_body = Enum.reverse(tile.body)

    tile
    |> Map.delete(:rotation)
    |> Map.put(:body, new_body)
    |> Map.put(:sides, sides(new_body))
  end

  def product_of_corner_ids(edges) do
    edges
    |> corners
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  defp corners(edges) do
    edges
    |> count_uniq_edges
    |> Enum.filter(fn
      {_, 4} -> true
      ______ -> false
    end)
    |> Enum.map(fn {id, _} -> id end)
  end

  defp count_uniq_edges(edges) do
    Enum.reduce(edges, %{}, fn
      {_, [%{id: id}]}, map ->
        Map.update(map, id, 1, &(&1 + 1))
      _, map ->
        map
    end)
  end
end
