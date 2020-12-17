defmodule Aoc2020.Day14DockingDataTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day14DockingData
  alias Aoc2020.Day14DockingData.{Memory, MemoryV2}

  test "memory mask" do
    memory = Memory.new
    memory = Memory.mask(memory, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
    memory = Memory.assign(memory, 8, 11)
    assert Memory.bit_at(memory, 8) == 73

    memory = Memory.assign(memory, 7, 101)
    assert Memory.bit_at(memory, 7) == 101

    memory = Memory.assign(memory, 8, 0)
    assert Memory.bit_at(memory, 8) == 64

    assert Memory.sum(memory) == 165
  end

  test "parse instruction" do
    assert parse_instruction("mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == {:mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"}
    assert parse_instruction("mem[8] = 11") == {:store, 8, 11}
    assert parse_instruction("mem[7] = 101") == {:store, 7, 101}
    assert parse_instruction("mem[8] = 0") == {:store, 8, 0}
  end

  test "part 1" do
    instructions = Enum.map(Input.strings(14), &parse_instruction/1)

    handle_instruction = fn
      {:store, address, value}, acc ->
        Memory.assign(acc, address, value)

      {:mask, mask}, acc ->
        Memory.mask(acc, mask)
    end

    memory = Enum.reduce(instructions, Memory.new, handle_instruction)
    IO.puts("")
    IO.puts("Part 1: #{Memory.sum(memory)}")
  end

  test "v2 memory address decoder" do
    memory = MemoryV2.new
    memory = MemoryV2.mask(memory, "000000000000000000000000000000X1001X")
    memory = MemoryV2.assign(memory, 42, 100)

    assert MemoryV2.bit(memory, 26) == 100
    assert MemoryV2.bit(memory, 27) == 100
    assert MemoryV2.bit(memory, 58) == 100
    assert MemoryV2.bit(memory, 59) == 100

    memory = MemoryV2.mask(memory, "00000000000000000000000000000000X0XX")
    memory = MemoryV2.assign(memory, 26, 1)

    assert MemoryV2.bit(memory, 16) == 1
    assert MemoryV2.bit(memory, 17) == 1
    assert MemoryV2.bit(memory, 18) == 1
    assert MemoryV2.bit(memory, 19) == 1
    assert MemoryV2.bit(memory, 24) == 1
    assert MemoryV2.bit(memory, 25) == 1
    assert MemoryV2.bit(memory, 26) == 1
    assert MemoryV2.bit(memory, 27) == 1

    assert MemoryV2.sum(memory) == 208
  end

  test "part 2" do
    instructions = Enum.map(Input.strings(14), &parse_instruction/1)

    handle_instruction = fn
      {:store, address, value}, acc ->
        MemoryV2.assign(acc, address, value)

      {:mask, mask}, acc ->
        MemoryV2.mask(acc, mask)
    end

    memory = Enum.reduce(instructions, MemoryV2.new, handle_instruction)
    IO.puts("")
    IO.puts("Part 2: #{MemoryV2.sum(memory)}")
  end
end
