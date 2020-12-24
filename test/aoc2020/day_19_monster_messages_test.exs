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

  @test2 """
  42: 9 14 | 10 1
  9: 14 27 | 1 26
  10: 23 14 | 28 1
  1: "a"
  11: 42 31 | 42 11 31
  5: 1 14 | 15 1
  19: 14 1 | 14 14
  12: 24 14 | 19 1
  16: 15 1 | 14 14
  31: 14 17 | 1 13
  6: 14 14 | 1 14
  2: 1 24 | 14 4
  0: 8 11
  13: 14 3 | 1 12
  15: 1 | 14
  17: 14 2 | 1 7
  23: 25 1 | 22 14
  28: 16 1
  4: 1 1
  20: 14 14 | 1 15
  3: 5 14 | 16 1
  27: 1 6 | 14 18
  14: "b"
  21: 14 1 | 1 14
  25: 1 1 | 1 14
  22: 14 14
  8: 42 | 42 8
  26: 14 22 | 1 20
  18: 15 15
  7: 14 5 | 1 21
  24: 14 1

  abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
  bbabbbbaabaabba
  babbbbaabbbbbabbbbbbaabaaabaaa
  aaabbbbbbaaaabaababaabababbabaaabbababababaaa
  bbbbbbbaaaabbbbaaabbabaaa
  bbbababbbbaaaaaaaabbababaaababaabab
  ababaaaaaabaaab
  ababaaaaabbbaba
  baabbaaaabbaaaababbaababb
  abbbbabbbbaaaababbbbbbaaaababb
  aaaaabbaabaaaaababaa
  aaaabbaaaabbaaa
  aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
  babaaabbbaaabaababbaabababaaab
  aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
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

    assert [{:ok, "pple"}] == StateMachine.accepts(lc, "apple", %{})
    assert [{:ok, "apple"}] == StateMachine.accepts(lc, "aapple", %{})
    assert [] == StateMachine.accepts(lc, "banana", %{})

    seq = Sequence.new(["1","1","1"])

    assert [{:ok, ""}] == StateMachine.accepts(seq, "aaa", %{"1" => lc})
    assert [{:ok, "bb"}] == StateMachine.accepts(seq, "aaabb", %{"1" => lc})
    assert [] == StateMachine.accepts(seq, "aab", %{"1" => lc})

    b = LetterChomper.new("b")
    oneof = OneOf.new([["1", "2"], ["2", "1"]])
    map = %{"1" => lc, "2" => b}

    assert [{:ok, ""}] == StateMachine.accepts(oneof, "ab", map)
    assert [{:ok, ""}] == StateMachine.accepts(oneof, "ba", map)
    assert [] == StateMachine.accepts(oneof, "bb", map)
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

  test "handle rule 8 (1 or more)" do
    example = """
    1: "a"
    2: 1 | 1 2

    b
    a
    aa
    aaa
    aaaaaaaaaaaaaaaa
    """ |> String.split("\n")

    {rules, messages} = parse(example)

    passes = Enum.count(messages, &satisfies?(&1, "2", rules))
    assert passes == 4
  end
end
