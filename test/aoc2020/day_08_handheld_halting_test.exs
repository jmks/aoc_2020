defmodule Aoc2020.Day08HandheldHaltingTest do
  use ExUnit.Case, async: true

  alias  Aoc2020.Day08HandheldHalting.Computer
  import Aoc2020.Day08HandheldHalting

  @test """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  test "trace" do
    assert {:halted, 5} == Computer.run_without_duplicate_lines(@test |> parse_instructions |> Computer.new)
  end

  test "solve part 1" do
    {:halted, result} = Computer.run_without_duplicate_lines(Input.raw(8) |> parse_instructions|> Computer.new)
    IO.puts("Part 1: #{result}")
  end
end
