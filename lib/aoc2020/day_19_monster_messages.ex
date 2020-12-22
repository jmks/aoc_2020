defmodule Aoc2020.Day19MonsterMessages do
  @moduledoc """
--- Day 19: Monster Messages ---
You land in an airport surrounded by dense forest. As you walk to your high-speed train, the Elves at the Mythical Information Bureau contact you again. They think their satellite has collected an image of a sea monster! Unfortunately, the connection to the satellite is having problems, and many of the messages sent back from the satellite have been corrupted.

They sent you a list of the rules valid messages should obey and a list of received messages they've collected so far (your puzzle input).

The rules for valid messages (the top part of your puzzle input) are numbered and build upon each other. For example:

0: 1 2
1: "a"
2: 1 3 | 3 1
3: "b"
Some rules, like 3: "b", simply match a single character (in this case, b).

The remaining rules list the sub-rules that must be followed; for example, the rule 0: 1 2 means that to match rule 0, the text being checked must match rule 1, and the text after the part that matched rule 1 must then match rule 2.

Some of the rules have multiple lists of sub-rules separated by a pipe (|). This means that at least one list of sub-rules must match. (The ones that match might be different each time the rule is encountered.) For example, the rule 2: 1 3 | 3 1 means that to match rule 2, the text being checked must match rule 1 followed by rule 3 or it must match rule 3 followed by rule 1.

Fortunately, there are no loops in the rules, so the list of possible matches will be finite. Since rule 1 matches a and rule 3 matches b, rule 2 matches either ab or ba. Therefore, rule 0 matches aab or aba.

Here's a more interesting example:

0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"
Here, because rule 4 matches a and rule 5 matches b, rule 2 matches two letters that are the same (aa or bb), and rule 3 matches two letters that are different (ab or ba).

Since rule 1 matches rules 2 and 3 once each in either order, it must match two pairs of letters, one pair with matching letters and one pair with different letters. This leaves eight possibilities: aaab, aaba, bbab, bbba, abaa, abbb, baaa, or babb.

Rule 0, therefore, matches a (rule 4), then any of the eight options from rule 1, then b (rule 5): aaaabb, aaabab, abbabb, abbbab, aabaab, aabbbb, abaaab, or ababbb.

The received messages (the bottom part of your puzzle input) need to be checked against the rules so you can determine which are valid and which are corrupted. Including the rules and the messages together, this might look like:

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

Your goal is to determine the number of messages that completely match rule 0. In the above example, ababbb and abbbab match, but bababa, aaabbb, and aaaabbb do not, producing the answer 2. The whole message must match all of rule 0; there can't be extra unmatched characters in the message. (For example, aaaabbb might appear to match rule 0 above, but it has an extra unmatched b on the end.)

How many messages completely match rule 0?
"""
  defprotocol StateMachine do
    def accepts(rule, message, rule_map)
  end

  defmodule LetterChomper do
    defstruct [:letter]

    def new(letter) do
      %__MODULE__{letter: letter}
    end
  end

  defimpl StateMachine, for: LetterChomper do
    def accepts(lc, message, _rules_map) do
      if String.starts_with?(message, lc.letter) do
        {:ok, String.slice(message, 1..-1)}
      else
        false
      end
    end
  end

  defmodule Sequence do
    defstruct [:rules]

    def new(rules) do
      %__MODULE__{rules: rules}
    end
  end

  defimpl StateMachine, for: Sequence do
    def accepts(seq, message, rules_map) do
      do_accepts(seq.rules, message, rules_map)
    end

    defp do_accepts([], message, _), do: {:ok, message}

    defp do_accepts([rule | rules], message, rules_map) do
      machine = Map.get(rules_map, rule)

      case StateMachine.accepts(machine, message, rules_map) do
        {:ok, rest} ->
          do_accepts(rules, rest, rules_map)

        false ->
          false
      end
    end
  end

  defmodule OneOf do
    defstruct [:rules]

    def new(rules) do
      %__MODULE__{rules: rules}
    end
  end

  defimpl StateMachine, for: OneOf do
    def accepts(oneof, message, rules_map) do
      Enum.find_value(oneof.rules, false, &do_accepts(&1, message, rules_map))
    end

    defp do_accepts(rule, message, rules_map) do
      seq = Sequence.new(rule)
      StateMachine.accepts(seq, message, rules_map)
    end
  end

  def parse(input) do
    rules =
      input
      |> Enum.take_while(&(&1 != ""))
      |> Enum.map(&parse_rule/1)
      |> Enum.into(%{})

    messages =
      input
      |> Enum.drop_while(&(&1 != ""))
      |> tl
      |> Enum.filter(fn m -> String.length(m) != 0 end)

    {rules, messages}
  end

  def satisfies?(message, rule, rules) do
    machines_map = map_machines(rules)
    machine = Map.get(machines_map, rule)

    case StateMachine.accepts(machine, message, machines_map) do
      {:ok, ""} -> true
      _________ -> false
    end
  end

  defp map_machines(rules) do
    rules
    |> Enum.map(fn
      {number, [letter]} when is_binary(letter) ->
        {number, LetterChomper.new(letter)}

      {number, [conditions]} ->
        {number, Sequence.new(conditions)}

      {number, [left, right]} ->
        {number, OneOf.new([left, right])}

    end)
    |> Enum.into(%{})
  end

  defp parse_rule(rule) do
    [number, rest] = String.split(rule, ": ", parts: 2)

    {number, parse_condition(rest)}
  end

  defp parse_condition(~s(") <> _ = char), do: [String.trim(char, ~s("))]
  defp parse_condition(condition) do
    case String.split(condition, " | ", parts: 2) do
      [left, right] ->
        [String.split(left, " ", parts: 2), String.split(right, " ", parts: 2)]

      _ ->
        [String.split(condition, " ")]
    end
  end
end
