defmodule Aoc2020.Day08HandheldHaltingTest do
  use ExUnit.Case, async: true

  alias  Aoc2020.Day08HandheldHalting.{Computer, InstructionRewriter}
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

  test "terminates successfully" do
    instructions = """
    acc +5
    nop -10
    """

    assert {:terminated, 5} == Computer.run_without_duplicate_lines(instructions |> parse_instructions |> Computer.new)
  end

  test "test rewriter" do
    assert 8 == run_rewriter(@test)
  end

  test "solve part 2" do
    IO.puts("Part 2: #{run_rewriter(Input.raw(8))}")
  end

  defp run_rewriter(instructions) do
    instructions
    |> parse_instructions
    |> InstructionRewriter.new
    |> InstructionRewriter.stream
    |> Enum.find_value(fn instructions ->
      case Computer.run_without_duplicate_lines(Computer.new(instructions)) do
        {:terminated, acc} ->
          acc
        {:halted, _} ->
          false
      end
    end)
  end
end
