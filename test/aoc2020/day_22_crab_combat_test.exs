defmodule Aoc2020.Day22CrabCombatTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day22CrabCombat
  alias Aoc2020.Day22CrabCombat.Combat

  test "plays combat" do
    combat = Combat.new([9, 2, 6, 3, 1], [5, 8, 4, 7, 10]) |> run_until_done

    assert Combat.score(combat) == 306
  end

  test "part 1" do
    {one, two} = puzzle

    result = Combat.new(one, two) |> run_until_done |> Combat.score

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end

  defp run_until_done(combat) do
    case Combat.round(combat) do
      {:ok, new_combat} ->
        run_until_done(new_combat)

      {:game_over, done} ->
        done
    end
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
