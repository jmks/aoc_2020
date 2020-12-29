defmodule Aoc2020.Day21AllergenAssessmentTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day21AllergenAssessment

  @food_list """
  mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
  trh fvjkl sbzzf mxmxvkd (contains dairy)
  sqjhc fvjkl (contains soy)
  sqjhc mxmxvkd sbzzf (contains fish)
  """ |> String.split("\n", trim: true)

  test "parse" do
    assert parse(@food_list) == [
      {~w(mxmxvkd kfcds sqjhc nhms), ~w(dairy fish)},
      {~w(trh fvjkl sbzzf mxmxvkd), ~w(dairy)},
      {~w(sqjhc fvjkl), ~w(soy)},
      {~w(sqjhc mxmxvkd sbzzf), ~w(fish)}
    ]
  end

  test "no allergen ingredients" do
    assert count_allergy_free_ingredients(@food_list |> parse) == 5
  end

  test "part 1" do
    result = Input.strings(21) |> parse |> count_allergy_free_ingredients

    IO.puts("Part 1: #{result}")
    IO.puts("")
  end
end
