defmodule Aoc2020.Day21AllergenAssessment do
  @moduledoc """
--- Day 21: Allergen Assessment ---
You reach the train's last stop and the closest you can get to your vacation island without getting wet. There aren't even any boats here, but nothing can stop you now: you build a raft. You just need a few days' worth of food for your journey.

You don't speak the local language, so you can't read any ingredients lists. However, sometimes, allergens are listed in a language you do understand. You should be able to use this information to determine which ingredient contains which allergen and work out which foods are safe to take with you on your trip.

You start by compiling a list of foods (your puzzle input), one food per line. Each line includes that food's ingredients list followed by some or all of the allergens the food contains.

Each allergen is found in exactly one ingredient. Each ingredient contains zero or one allergen. Allergens aren't always marked; when they're listed (as in (contains nuts, shellfish) after an ingredients list), the ingredient that contains each listed allergen will be somewhere in the corresponding ingredients list. However, even if an allergen isn't listed, the ingredient that contains that allergen could still be present: maybe they forgot to label it, or maybe it was labeled in a language you don't know.

For example, consider the following list of foods:

mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)

The first food in the list has four ingredients (written in a language you don't understand): mxmxvkd, kfcds, sqjhc, and nhms. While the food might contain other allergens, a few allergens the food definitely contains are listed afterward: dairy and fish.

The first step is to determine which ingredients can't possibly contain any of the allergens in any food in your list. In the above example, none of the ingredients kfcds, nhms, sbzzf, or trh can contain an allergen. Counting the number of times any of these ingredients appear in any ingredients list produces 5: they all appear once each except sbzzf, which appears twice.

Determine which ingredients cannot possibly contain any of the allergens in your list. How many times do any of those ingredients appear?
"""
  def parse(food_list) do
    Enum.map(food_list, fn entry ->
      [ingredients, allergens] = String.split(entry, "(contains ", parts: 2, trim: true)

      {String.split(ingredients, " ", trim: true), allergens |> String.trim_trailing(")") |> String.split(", ")}
    end)
  end

  def count_allergy_free_ingredients(foods) do
    allergy_free = allergen_free_ingredients(foods)

    Enum.reduce(foods, 0, fn {ingredients, _}, count ->
      ingredient_count = ingredients |> MapSet.new |> MapSet.intersection(allergy_free) |> MapSet.size

      count + ingredient_count
    end)
  end

  def allergen_free_ingredients(foods) do
    allergen_options = possible_allergen_ingredients(foods)
    potentially_allergic_ingredients = Enum.reduce(allergen_options, MapSet.new, fn {_, ingredients}, set ->
      MapSet.union(set, ingredients)
    end)
    all_ingredients = Enum.flat_map(foods, &elem(&1, 0)) |> Enum.into(MapSet.new)

    MapSet.difference(all_ingredients, potentially_allergic_ingredients)
  end

  def possible_allergen_ingredients(foods) do
    foods
    |> Enum.reduce(%{}, fn {ingredients, allergens}, outer_map ->
      allergen_ingredients = MapSet.new(ingredients)

      Enum.reduce(allergens, outer_map, fn allergen, map ->
        Map.update(map, allergen, allergen_ingredients, fn previous ->
          MapSet.intersection(previous, allergen_ingredients)
        end)
      end)
    end)
  end
end
