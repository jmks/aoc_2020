defmodule Aoc2020.Day15RambunctiousRecitationTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day15RambunctiousRecitation
  alias Aoc2020.Day15RambunctiousRecitation.MemoryGame

  test "game trace" do
    game = MemoryGame.new("0,3,6")

    assert game.turn == 1
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 0

    assert game.turn == 2
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 3

    assert game.turn == 3
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 6

    assert game.turn == 4
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 0

    assert game.turn == 5
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 3

    assert game.turn == 6
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 3

    assert game.turn == 7
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 1

    assert game.turn == 8
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 0

    assert game.turn == 9
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 4

    assert game.turn == 10
    {spoken, game} = MemoryGame.say(game)
    assert spoken == 0

    assert said_on_turn(game, 2020) == 436
  end

  test "said on turn 2020" do
    assert said_on_turn(MemoryGame.new("1,3,2"), 2020) == 1
    assert said_on_turn(MemoryGame.new("2,1,3"), 2020) == 10
    assert said_on_turn(MemoryGame.new("1,2,3"), 2020) == 27
    assert said_on_turn(MemoryGame.new("2,3,1"), 2020) == 78
    assert said_on_turn(MemoryGame.new("3,2,1"), 2020) == 438
    assert said_on_turn(MemoryGame.new("3,1,2"), 2020) == 1836
  end

  test "part 1" do
    said = said_on_turn(MemoryGame.new(Input.raw(15)), 2020)

    IO.puts("")
    IO.puts("Part 1: #{said}")
  end

  defp said_on_turn(game, turn) do
    diff = turn - game.turn + 1
    game = Enum.reduce(1..diff, game, fn _, g ->
      g |> MemoryGame.say |> elem(1)
    end)

    game.most_recently_spoken
  end
end
