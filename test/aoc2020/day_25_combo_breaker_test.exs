defmodule Aoc2020.Day25ComboBreakerTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day25ComboBreaker

  test "calculating keys" do
    assert transform(7, 8) == 5764801
    assert transform(7, 11) == 17807724
  end

  test "finding loop sizes" do
    assert find_loop_size(5764801) == 8
    assert find_loop_size(17807724) == 11
  end

  test "part 1" do
    [card, door] = Input.ints(25)

    card_loop = find_loop_size(card)
    door_loop = find_loop_size(door)

    assert transform(card, door_loop) == transform(door, card_loop)

    IO.puts("")
    IO.puts("Part 1: #{transform(card, door_loop)}")
  end
end
