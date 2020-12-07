defmodule Aoc2020.Day07HandyHaversacksTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day07HandyHaversacks

  @test """
  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.
  """

  test "parsing rules" do
    assert parse("light red bags contain 1 bright white bag, 2 muted yellow bags.") == {"light red", %{"bright white" => 1, "muted yellow" => 2}}
    assert parse("dark orange bags contain 3 bright white bags, 4 muted yellow bags.") == {"dark orange", %{"bright white" => 3, "muted yellow" => 4}}
    assert parse("bright white bags contain 1 shiny gold bag.") == {"bright white", %{"shiny gold" => 1}}
    assert parse("muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.") == {"muted yellow", %{"shiny gold" => 2, "faded blue" => 9}}
    assert parse("faded blue bags contain no other bags.") == {"faded blue", %{}}
  end

  test "bag colours containing a shiny gold bag" do
    rules = @test |> String.split("\n", trim: true) |> Enum.map(&parse/1) |> Enum.into(%{})
    assert colours_containing(rules, "shiny gold") == 4
  end

  test "solve part 1" do
    rules = Input.strings(7) |> Enum.map(&parse/1) |> Enum.into(%{})
    result = colours_containing(rules, "shiny gold")

    IO.puts("")
    IO.puts("Part 1: #{result}")
  end
end
