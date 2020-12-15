defmodule Aoc2020.Day13ShuttleSearchTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day13ShuttleSearch

  test "earliest bus" do
    assert earliest_bus(939, "7,13,x,x,59,x,31,19") == {59, 5}
  end

  test "part 1" do
    [timestamp, schedules] = Input.strings(13)
    {bus, wait} = earliest_bus(String.to_integer(timestamp), schedules)

    IO.puts("")
    IO.puts("Part 1: #{bus * wait}")
  end
end
