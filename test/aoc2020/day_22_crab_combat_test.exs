defmodule Aoc2020.Day22CrabCombatTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day22CrabCombat
  alias Aoc2020.Day22CrabCombat.Combat

  test "plays combat" do
    combat = Combat.new([9, 2, 6, 3, 1], [5, 8, 4, 7, 10]) |> Combat.play_until_done

    assert Combat.score(combat) == 306
  end

  test "part 1" do
    {one, two} = puzzle()

    result = Combat.new(one, two) |> Combat.play_until_done |> Combat.score

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end

  test "plays recursive combat" do
    combat = Combat.new([9, 2, 6, 3, 1], [5, 8, 4, 7, 10], :recursive) |> Combat.play_until_done

    assert Combat.score(combat) == 291
  end

  test "game does not loop forever" do
    combat = Combat.new([43, 19], [2, 29, 14], :recursive) |> Combat.play_until_done

    assert Combat.done?(combat)
  end

  test "part 2" do
    {one, two} = puzzle()

    result = Combat.new(one, two, :recursive) |> Combat.play_until_done |> Combat.score

    IO.puts("")
    IO.puts("Part 2: #{result}")
  end

  defp puzzle do
    [_ | rest] = Input.strings(22)

    player_1 =
      rest
      |> Enum.take_while(fn line -> String.length(line) != 0 end)
      |> Enum.map(&String.to_integer/1)

    player_2 =
      rest
      |> Enum.drop_while(fn line -> String.length(line) != 0 end)
      |> Enum.drop(2)
      |> Enum.map(&String.to_integer/1)

    {player_1, player_2}
  end
end
