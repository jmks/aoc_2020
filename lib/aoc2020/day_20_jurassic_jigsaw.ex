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

--- Part Two ---

Now, you're ready to check the image for sea monsters.

The borders of each tile are not part of the actual image; start by removing them.

In the example above, the tiles become:

.#.#..#. ##...#.# #..#####
###....# .#....#. .#......
##.##.## #.#.#..# #####...
###.#### #...#.## ###.#..#
##.#.... #.##.### #...#.##
...##### ###.#... .#####.#
....#..# ...##..# .#.###..
.####... #..#.... .#......

#..#.##. .#..###. #.##....
#.####.. #.####.# .#.###..
###.#.#. ..#.#### ##.#..##
#.####.. ..##..## ######.#
##..##.# ...#...# .#.#.#..
...#..#. .#.#.##. .###.###
.#.#.... #.##.#.. .###.##.
###.#... #..#.##. ######..

.#.#.### .##.##.# ..#.##..
.####.## #.#...## #.#..#.#
..#.#..# ..#.#.#. ####.###
#..####. ..#.#.#. ###.###.
#####..# ####...# ##....##
#.##..#. .#...#.. ####...#
.#.###.. ##..##.. ####.##.
...###.. .##...#. ..#..###

Remove the gaps to form the actual image:

.#.#..#.##...#.##..#####
###....#.#....#..#......
##.##.###.#.#..######...
###.#####...#.#####.#..#
##.#....#.##.####...#.##
...########.#....#####.#
....#..#...##..#.#.###..
.####...#..#.....#......
#..#.##..#..###.#.##....
#.####..#.####.#.#.###..
###.#.#...#.######.#..##
#.####....##..########.#
##..##.#...#...#.#.#.#..
...#..#..#.#.##..###.###
.#.#....#.##.#...###.##.
###.#...#..#.##.######..
.#.#.###.##.##.#..#.##..
.####.###.#...###.#..#.#
..#.#..#..#.#.#.####.###
#..####...#.#.#.###.###.
#####..#####...###....##
#.##..#..#...#..####...#
.#.###..##..##..####.##.
...###...##...#...#..###

Now, you're ready to search for sea monsters! Because your image is monochrome, a sea monster will look like this:

                  #
#    ##    ##    ###
 #  #  #  #  #  #

When looking for this pattern in the image, the spaces can be anything; only the # need to match. Also, you might need to rotate or flip your image before it's oriented correctly to find sea monsters. In the above image, after flipping and rotating it to the appropriate orientation, there are two sea monsters (marked with O):

.####...#####..#...###..
#####..#..#.#.####..#.#.
.#.#...#.###...#.##.O#..
#.O.##.OO#.#.OO.##.OOO##
..#O.#O#.O##O..O.#O##.##
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
#.###...#.##...#.##O###.
.O##.#OO.###OO##..OOO##.
..O#.O..O..O.#O##O##.###
#.#..##.########..#..##.
#.#####..#.#...##..#....
#....##..#.#########..##
#...#.....#..##...###.##
#..###....##.#...##.##.#

Determine how rough the waters are in the sea monsters' habitat by counting the number of # that are not part of a sea monster. In the above example, the habitat's water roughness is 273.

How many # are not part of a sea monster?
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

  def image(arrangement) do
    side_length = length(arrangement) |> :math.sqrt |> round

    arrangement
    |> Enum.map(fn %{body: body} ->
      len = length(body)

      body
      |> Enum.slice(1..(len - 2))
      |> Enum.map(fn str ->
        len = String.length(str)

        String.slice(str, 1..(len - 2)) |> String.codepoints
      end)
    end)
    |> Enum.chunk_every(side_length)
    |> Enum.with_index
    |> Enum.flat_map(fn {chunk, index} ->
      chunk = if rem(index, 2) == 0, do: chunk, else: Enum.reverse(chunk)

      chunk
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&List.flatten/1)
    end)
  end

  def rotate_until_monsters(image) do
    flipped_images = [
      image,
      flip_image(image, :horizontal),
      flip_image(image, :vertical)
    ]
    image_with_monster = Enum.find(flipped_images, &has_monster?/1)

    image_with_monster || rotate_until_monsters(rotate_image(image))
  end

  def monsters_in_rotation(image) do
    do_monsters_in_rotation(image, [])
  end

  defp do_monsters_in_rotation(image, rotations) when length(rotations) == 12 do
    rotations
  end

  defp do_monsters_in_rotation(image, rotations) do
    new_rotations = [
      {:none, count_monsters(image)},
      {:h, count_monsters(flip_image(image, :horizontal))},
      {:v, count_monsters(flip_image(image, :vertical))}
    ]

    do_monsters_in_rotation(rotate_image(image), new_rotations ++ rotations)
  end

  def roughness(arrangement) do
    image = image(arrangement)

    [
      image,
      image |> rotate_image,
      image |> rotate_image |> rotate_image,
      image |> rotate_image |> rotate_image |> rotate_image,
    ]
    |> Enum.map(&roughness(coordinates(&1), rough_waters(&1), rough_waters(&1)))
    |> Enum.min
  end

  defp roughness([], _original, waters), do: MapSet.size(waters)

  defp roughness([coordinate | rest], original, outer_waters) do
    new_waters =
      seamonster_coordinates(coordinate, original)
      |> Enum.reduce(outer_waters, fn coordinate, waters ->
        MapSet.delete(waters, coordinate)
      end)

    roughness(rest, original, new_waters)
  end

  def rotate_image(image) do
    image
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.reverse/1)
  end

  defp flip_image(image, :horizontal) do
    Enum.map(image, &Enum.reverse/1)
  end

  defp flip_image(image, :vertical) do
    Enum.reverse(image)
  end

  def coordinates(image) do
    rows = length(image)
    cols = length(hd(image))

    for row <- 0..(rows - 1), col <- 0..(cols - 1), do: {row, col}
  end

  def rough_waters(image) do
    image
    |> Enum.with_index
    |> Enum.reduce(MapSet.new, fn {row, rindex}, outer_set ->
      row
      |> Enum.with_index
      |> Enum.filter(fn
        {"#", _} -> true
        ________ -> false
      end)
      |> Enum.reduce(outer_set, fn {_, cindex}, set ->
        MapSet.put(set, {rindex, cindex})
      end)
    end)
  end

  defp has_monster?(image) do
    waters = rough_waters(image)

    coordinates(image)
    |> Enum.any?(fn coordinate ->
      monster = seamonster(coordinate, {1, 1})
      Enum.all?(monster, &MapSet.member?(waters, &1))
    end)
  end

  def count_monsters(image) do
    waters = rough_waters(image)

    coordinates(image)
    |> Enum.count(fn coordinate ->
      monster = seamonster(coordinate, {1, 1})

      Enum.all?(monster, &MapSet.member?(waters, &1))
    end)
  end

  def seamonster_coordinates(coordinate, waters) do
    [
      seamonster(coordinate, {1, 1}),
      seamonster(coordinate, {1, -1}),
      seamonster(coordinate, {-1, 1}),
      seamonster(coordinate, {-1, -1})
    ]
    |> Enum.map(&matching(waters, &1))
    |> List.flatten
  end

  def matching(set, coordinates) do
    if Enum.all?(coordinates, &MapSet.member?(set, &1)) do
      coordinates
    else
      []
    end
  end

  def seamonster(coordinate, {rot_x, rot_y}) do
    seamonster_offsets()
    |> Enum.map(fn {x, y} ->
      add({rot_x * x, rot_y * y}, coordinate)
    end)
  end

  # the leading # is not part of the pattern:
  #                  #
  ##    ##    ##    ###
  # #  #  #  #  #  #
  defp seamonster_offsets do
    [
      {0, 18},
      {1, 0}, {1, 5}, {1, 6}, {1, 11}, {1, 12}, {1, 17}, {1, 18}, {1, 19},
      {2, 1}, {2, 4}, {2, 7}, {2, 10}, {2, 13}, {2, 16}
    ]
  end

  defp add({xo, yo}, {x1, y1}), do: {xo + x1, yo + y1}
end
