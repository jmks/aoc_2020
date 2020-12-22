defmodule Aoc2020.Day19MonsterMessagesTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day19MonsterMessages
  alias Aoc2020.Day19MonsterMessages.{StateMachine, LetterChomper, Sequence, OneOf}

  @test """
  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"

  ababbb
  bababa
  abbbab
  aaabbb
  aaaabbb
  """ |> String.split("\n")

  test "parsing" do
    assert parse(@test) == {
      %{
        "0" => [["4","1","5"]],
        "1" => [["2","3"], ["3","2"]],
        "2" => [["4","4"], ["5","5"]],
        "3" => [["4","5"], ["5","4"]],
        "4" => ["a"],
        "5" => ["b"]
      },
      [
        "ababbb",
        "bababa",
        "abbbab",
        "aaabbb",
        "aaaabbb"
      ]
    }
  end

  test "state machines" do
    lc = LetterChomper.new("a")

    assert {:ok, "pple"} == StateMachine.accepts(lc, "apple", %{})
    assert {:ok, "apple"} == StateMachine.accepts(lc, "aapple", %{})
    assert false == StateMachine.accepts(lc, "banana", %{})

    seq = Sequence.new(["1","1","1"])

    assert {:ok, ""} == StateMachine.accepts(seq, "aaa", %{"1" => lc})
    assert {:ok, "bb"} == StateMachine.accepts(seq, "aaabb", %{"1" => lc})
    assert false == StateMachine.accepts(seq, "aab", %{"1" => lc})

    b = LetterChomper.new("b")
    oneof = OneOf.new([["1", "2"], ["2", "1"]])
    map = %{"1" => lc, "2" => b}

    assert {:ok, ""} == StateMachine.accepts(oneof, "ab", map)
    assert {:ok, ""} == StateMachine.accepts(oneof, "ba", map)
    assert false == StateMachine.accepts(oneof, "bb", map)
  end

  test "satisfies?" do
    rules = %{
      "0" => [["4","1","5"]],
      "1" => [["2","3"], ["3","2"]],
      "2" => [["4","4"], ["5","5"]],
      "3" => [["4","5"], ["5","4"]],
      "4" => ["a"],
      "5" => ["b"]
    }

    assert satisfies?("ababbb", "0", rules)
    assert satisfies?("abbbab", "0", rules)
    refute satisfies?("bababa", "0", rules)
    refute satisfies?("aaabbb", "0", rules)
    refute satisfies?("aaaabbb", "0", rules)
  end

  test "part 1" do
    {rules, messages} = parse(Input.strings(19))

    count = Enum.count(messages, fn message -> satisfies?(message, "0", rules) end)

    IO.puts("Part 1: #{count}")
    IO.puts("")
  end
end
