defmodule Aoc2020.Day08HandheldHalting do
  @moduledoc """
  --- Day 8: Handheld Halting ---
  Your flight to the major airline hub reaches cruising altitude without incident. While you consider checking the in-flight menu for one of those drinks that come with a little umbrella, you are interrupted by the kid sitting next to you.

  Their handheld game console won't turn on! They ask if you can take a look.

  You narrow the problem down to a strange infinite loop in the boot code (your puzzle input) of the device. You should be able to fix it, but first you need to be able to run the code in isolation.

  The boot code is represented as a text file with one instruction per line of text. Each instruction consists of an operation (acc, jmp, or nop) and an argument (a signed number like +4 or -20).

  acc increases or decreases a single global value called the accumulator by the value given in the argument. For example, acc +7 would increase the accumulator by 7. The accumulator starts at 0. After an acc instruction, the instruction immediately below it is executed next.
  jmp jumps to a new instruction relative to itself. The next instruction to execute is found using the argument as an offset from the jmp instruction; for example, jmp +2 would skip the next instruction, jmp +1 would continue to the instruction immediately below it, and jmp -20 would cause the instruction 20 lines above to be executed next.
  nop stands for No OPeration - it does nothing. The instruction immediately below it is executed next.
  For example, consider the following program:

  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  These instructions are visited in this order:

  nop +0  | 1
  acc +1  | 2, 8(!)
  jmp +4  | 3
  acc +3  | 6
  jmp -3  | 7
  acc -99 |
  acc +1  | 4
  jmp -4  | 5
  acc +6  |
  First, the nop +0 does nothing. Then, the accumulator is increased from 0 to 1 (acc +1) and jmp +4 sets the next instruction to the other acc +1 near the bottom. After it increases the accumulator from 1 to 2, jmp -4 executes, setting the next instruction to the only acc +3. It sets the accumulator to 5, and jmp -3 causes the program to continue back at the first acc +1.

  This is an infinite loop: with this sequence of jumps, the program will run forever. The moment the program tries to run any instruction a second time, you know it will never terminate.

  Immediately before the program would run an instruction a second time, the value in the accumulator is 5.

  Run your copy of the boot code. Immediately before any instruction is executed a second time, what value is in the accumulator?
  """

  defmodule Computer do
    defstruct [:instructions, :accumulator, :program_counter, :executed]

    def new(instructions) do
      %__MODULE__{instructions: instructions, accumulator: 0, program_counter: 0, executed: MapSet.new}
    end

    def run_without_duplicate_lines(computer, trace \\ false) do
      if MapSet.member?(computer.executed, computer.program_counter) do
        {:halted, computer.accumulator}
      else
        instruction = Enum.at(computer.instructions, computer.program_counter)

        if trace, do: IO.puts("#{inspect instruction}  | #{MapSet.size(computer.executed) + 1} (#{computer.accumulator})")

        new_computer = execute(computer, instruction)
        run_without_duplicate_lines(new_computer)
      end
    end

    defp execute(computer, instruction) do
      case instruction do
        {:acc, arg} ->
          new_pc = computer.program_counter + 1
          new_acc = computer.accumulator + arg
          new_exe = MapSet.put(computer.executed, computer.program_counter)

          %{computer | program_counter: new_pc, accumulator: new_acc, executed: new_exe}

        {:nop, _arg} ->
          new_pc = computer.program_counter + 1
          new_exe = MapSet.put(computer.executed, computer.program_counter)

          %{computer | program_counter: new_pc, executed: new_exe}

        {:jmp, arg} ->
          new_pc = computer.program_counter + arg
          new_exe = MapSet.put(computer.executed, computer.program_counter)

          %{computer | program_counter: new_pc, executed: new_exe}
      end
    end
  end

  def parse_instructions(instructions) do
    instructions
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "acc " <> arg ->
        {:acc, parse_argument(arg)}

      "nop " <> arg ->
        {:nop, parse_argument(arg)}

      "jmp " <> arg ->
        {:jmp, parse_argument(arg)}
    end)
  end

  defp parse_argument(arg) do
    {int, ""} = Integer.parse(arg)
    int
  end
end
