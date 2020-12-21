defmodule Aoc2020.Day18OperationOrder do
  @moduledoc """
--- Day 18: Operation Order ---

As you look out the window and notice a heavily-forested continent slowly appear over the horizon, you are interrupted by the child sitting next to you. They're curious if you could help them with their math homework.

Unfortunately, it seems like this "math" follows different rules than you remember.

The homework (your puzzle input) consists of a series of expressions that consist of addition (+), multiplication (*), and parentheses ((...)). Just like normal math, parentheses indicate that the expression inside must be evaluated before it can be used by the surrounding expression. Addition still finds the sum of the numbers on both sides of the operator, and multiplication still finds the product.

However, the rules of operator precedence have changed. Rather than evaluating multiplication before addition, the operators have the same precedence, and are evaluated left-to-right regardless of the order in which they appear.

For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are as follows:

1 + 2 * 3 + 4 * 5 + 6
  3   * 3 + 4 * 5 + 6
      9   + 4 * 5 + 6
         13   * 5 + 6
             65   + 6
                 71
Parentheses can override this order; for example, here is what happens if parentheses are added to form 1 + (2 * 3) + (4 * (5 + 6)):

1 + (2 * 3) + (4 * (5 + 6))
1 +    6    + (4 * (5 + 6))
     7      + (4 * (5 + 6))
     7      + (4 *   11   )
     7      +     44
            51
Here are a few more examples:

2 * 3 + (4 * 5) becomes 26.
5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 437.
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 12240.
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 13632.

Before you can help with the homework, you need to understand it yourself. Evaluate the expression on each line of the homework; what is the sum of the resulting values?

--- Part Two ---

You manage to answer the child's questions and they finish part 1 of their homework, but get stuck when they reach the next section: advanced math.

Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar with. Instead, addition is evaluated before multiplication.

For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:

1 + 2 * 3 + 4 * 5 + 6
3   * 3 + 4 * 5 + 6
3   *   7   * 5 + 6
3   *   7   *  11
21       *  11
231

Here are the other examples from above:

1 + (2 * 3) + (4 * (5 + 6)) still becomes 51.
2 * 3 + (4 * 5) becomes 46.
5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 1445.
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 669060.
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 23340.

What do you get if you add up the results of evaluating the homework problems using these new rules?
"""
  def parse(homework) do
    homework
    |> String.graphemes
    |> Enum.filter(&(&1 != " "))
    |> do_parse([])
  end

  def eval(tokens) do
    priorities = %{
      parens: 1,
      mul: 2,
      add: 2,
      num: 4
    }

    evaluate_with_priorities(tokens, priorities)
  end

  def eval2(tokens) do
    priorities = %{
      parens: 1,
      add: 2,
      mul: 3,
      num: 4
    }

    evaluate_with_priorities(tokens, priorities)
  end

  def evaluate_with_priorities([result], _) when is_integer(result), do: result

  def evaluate_with_priorities([left, :mul, right], _) when is_integer(left) and is_integer(right) do
    left * right
  end

  def evaluate_with_priorities([left, :add, right], _) when is_integer(left) and is_integer(right) do
    left + right
  end

  def evaluate_with_priorities({:parens, exprs}, priorities), do: evaluate_with_priorities(exprs, priorities)

  def evaluate_with_priorities(tokens, priorities) do
    {leading, next_expr, trailing} = find_next(tokens, priorities)
    evaluate_with_priorities(leading ++ [evaluate_with_priorities(next_expr, priorities)] ++ trailing, priorities)
  end

  defp do_parse([], tokens), do: Enum.reverse(tokens)

  defp do_parse(["+" | rest], tokens), do: do_parse(rest, [:add | tokens])

  defp do_parse(["*" | rest], tokens), do: do_parse(rest, [:mul | tokens])

  defp do_parse(["(" | rest], tokens) do
    {sub, rest} = subexpr(rest, [], 1)
    expr = do_parse(sub, [])

    do_parse(rest, [{:parens, expr} | tokens])
  end

  defp do_parse([number | rest], tokens) do
    do_parse(rest, [String.to_integer(number) | tokens])
  end

  defp subexpr([")" | rest], chars,     1), do: {Enum.reverse(chars), rest}
  defp subexpr([")" | rest], chars, level), do: subexpr(rest, [")" | chars], level - 1)
  defp subexpr(["(" | rest], chars, level), do: subexpr(rest, ["(" | chars], level + 1)
  defp subexpr([ch  | rest], chars, level), do: subexpr(rest, [ch | chars], level)

  defp find_next(tokens, priorities) do
    next_range =
      tokens
      |> prioritize(priorities)
      |> hd
      |> elem(1)

    case next_range do
      0..max ->
        leading = []
        next = Enum.take(tokens, max+1)
        trailing = Enum.drop(tokens, max+1)

        {leading, next, trailing}

      min..max ->
        leading = Enum.take(tokens, min)
        next = tokens |> Enum.drop(min) |> Enum.take(max - min + 1)
        trailing = Enum.drop(tokens, max+1)

        {leading, next, trailing}

      index ->
        {Enum.take(tokens, index), Enum.at(tokens, index), Enum.drop(tokens, index+1)}
    end
  end

  defp prioritize(tokens, priorities) do
    tokens
    |> Enum.with_index
    |> Enum.map(fn
      {{:parens, _}, index} -> {Map.get(priorities, :parens), index}
      {:add, index} -> {Map.get(priorities, :add), (index-1)..(index+1)}
      {:mul, index} -> {Map.get(priorities, :mul), (index-1)..(index+1)}
      {_, index} -> {Map.get(priorities, :num), index}
    end)
    |> Enum.sort_by(fn {p, _} -> p end)
  end
end
