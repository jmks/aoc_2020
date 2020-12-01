defmodule Aoc2020.Day01ReportRepairTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day01ReportRepair

  test "finds numbers summing to 2020" do
    numbers = [1721, 979, 366, 299, 675, 1456]

    assert MapSet.new([1721, 299]) == sum_to_twenty_twenty(numbers)
  end

  test "solve part 1" do
    numbers = Input.ints(1)

    IO.puts("")
    IO.puts("Part 1: #{numbers |> sum_to_twenty_twenty |> Enum.reduce(1, &Kernel.*/2)}")
  end
end
