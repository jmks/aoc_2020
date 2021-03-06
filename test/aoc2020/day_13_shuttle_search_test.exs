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

  test "earliest timestamp" do
    assert earliest_timestamp("17,x,13,19") == 3417
    assert earliest_timestamp("67,7,59,61") == 754018
    assert earliest_timestamp("67,x,7,59,61") == 779210
    assert earliest_timestamp("67,7,x,59,61") == 1261476
    assert earliest_timestamp("1789,37,47,1889") == 1202161486
  end

  test "part 2" do
    [_timestamp, schedules] = Input.strings(13)
    result = earliest_timestamp(schedules)

    IO.puts("")
    IO.puts("Part 2: #{result}")
  end
end
