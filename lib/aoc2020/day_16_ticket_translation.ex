defmodule Aoc2020.Day16TicketTranslation do
  @moduledoc """
--- Day 16: Ticket Translation ---
As you're walking to yet another connecting flight, you realize that one of the legs of your re-routed trip coming up is on a high-speed train. However, the train ticket you were given is in a language you don't understand. You should probably figure out what it says before you get to the train station after the next flight.

Unfortunately, you can't actually read the words on the ticket. You can, however, read the numbers, and so you figure out the fields these tickets must have and the valid ranges for values in those fields.

You collect the rules for ticket fields, the numbers on your ticket, and the numbers on other nearby tickets for the same train service (via the airport security cameras) together into a single document you can reference (your puzzle input).

The rules for ticket fields specify a list of fields that exist somewhere on the ticket and the valid ranges of values for each field. For example, a rule like class: 1-3 or 5-7 means that one of the fields in every ticket is named class and can be any value in the ranges 1-3 or 5-7 (inclusive, such that 3 and 5 are both valid in this field, but 4 is not).

Each ticket is represented by a single line of comma-separated values. The values are the numbers on the ticket in the order they appear; every ticket has the same format. For example, consider this ticket:

.--------------------------------------------------------.
| ????: 101    ?????: 102   ??????????: 103     ???: 104 |
|                                                        |
| ??: 301  ??: 302             ???????: 303      ??????? |
| ??: 401  ??: 402           ???? ????: 403    ????????? |
'--------------------------------------------------------'
Here, ? represents text in a language you don't understand. This ticket might be represented as 101,102,103,104,301,302,303,401,402,403; of course, the actual train tickets you're looking at are much more complicated. In any case, you've extracted just the numbers in such a way that the first number is always the same specific field, the second number is always a different specific field, and so on - you just don't know what each position actually means!

Start by determining which tickets are completely invalid; these are tickets that contain values which aren't valid for any field. Ignore your ticket for now.

For example, suppose you have the following notes:

class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12

It doesn't matter which position corresponds to which field; you can identify invalid nearby tickets by considering only whether tickets contain values that are not valid for any field. In this example, the values on the first nearby ticket are all valid for at least one field. This is not true of the other three nearby tickets: the values 4, 55, and 12 are are not valid for any field. Adding together all of the invalid values produces your ticket scanning error rate: 4 + 55 + 12 = 71.

Consider the validity of the nearby tickets you scanned. What is your ticket scanning error rate?

--- Part Two ---

Now that you've identified which tickets contain invalid values, discard those tickets entirely. Use the remaining valid tickets to determine which field is which.

Using the valid ranges for each field, determine what order the fields appear on the tickets. The order is consistent between all tickets: if seat is the third field, it is the third field on every ticket, including your ticket.

For example, suppose you have the following notes:

class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9

Based on the nearby tickets in the above example, the first position must be row, the second position must be class, and the third position must be seat; you can conclude that in your ticket, class is 12, row is 11, and seat is 13.

Once you work out which field is which, look for the six fields on your ticket that start with the word departure. What do you get if you multiply those six values together?
"""

  defmodule Info do
    defstruct [:constraints, :mine, :nearby]

    def parse(notes) do
      nonempty_line = fn l -> String.length(l) != 0 end

      constraints = Enum.take_while(notes, nonempty_line)
      your_ticket =
        notes
        |> Enum.drop_while(fn l -> not String.starts_with?(l, "your ticket:") end)
        |> tl
        |> Enum.take_while(nonempty_line)

      nearby_tickets =
        notes
        |> Enum.drop_while(fn l -> not String.starts_with?(l, "nearby tickets:") end)
        |> tl
        |> Enum.take_while(nonempty_line)

      %__MODULE__{
        constraints: parse_constraints(constraints),
        mine: parse_tickets(your_ticket) |> hd,
        nearby: parse_tickets(nearby_tickets)
      }
    end

    def discard_invalid_tickets(info) do
      ranges = info.constraints |> Map.values |> List.flatten
      in_some_range = fn value -> Enum.any?(ranges, fn range -> value in range end) end

      valid_nearby = Enum.filter(info.nearby, fn ticket ->
        Enum.all?(ticket, in_some_range)
      end)

      %{info | nearby: valid_nearby}
    end

    def column_assignment(info) do
      info.nearby
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.with_index
      |> options_for_columns(info.constraints)
      |> valid_assignment
    end

    defp options_for_columns(columns, constraints) do
      Enum.reduce(constraints, %{}, fn {name, constraints}, assignment ->
        valid_indexes =
          columns
          |> Enum.filter(fn {column, _index} ->
          Enum.all?(column, fn value ->
            Enum.any?(constraints, fn range -> value in range end)
          end)
        end)
        |> Enum.map(fn {_, index} -> index end)

        Map.put(assignment, name, valid_indexes)
      end)
    end

    defp valid_assignment(options) do
      if Enum.all?(options, fn {_, v} -> length(v) == 1 end) do
        options
        |> Enum.map(fn {k, v} -> {v, k} end)
        |> Enum.sort_by(fn {i, _} -> i end)
        |> Enum.map(fn {_, v} -> v end)
      else
        assigned =
          options
          |> Enum.filter(fn {_, v} -> length(v) == 1 end)
          |> Enum.flat_map(fn {_, v} -> v end)
          |> Enum.into(MapSet.new)

        assignments_removed = Enum.reduce(options, %{}, fn {field, valid_indexes}, acc ->
          if length(valid_indexes) == 1 do
            Map.put(acc, field, valid_indexes)
          else
            Map.put(acc, field, Enum.filter(valid_indexes, fn index -> index not in assigned end))
          end
        end)

        valid_assignment(assignments_removed)
      end
    end

    defp parse_constraints(constraints) do
      Enum.map(constraints, fn line ->
        [name, or_range] = String.split(line, ": ", parts: 2, trim: true)
        ranges = String.split(or_range, " or ")

        {name, parse_ranges(ranges)}
      end)
      |> Enum.into(%{})
    end

    defp parse_ranges(ranges) do
      Enum.map(ranges, fn range ->
        [min, max] = String.split(range, "-", parts: 2)

        String.to_integer(min)..String.to_integer(max)
      end)
    end

    defp parse_tickets(tickets) do
      Enum.map(tickets, fn ticket ->
        ticket |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
      end)
    end
  end

  def scanning_error_rate(info) do
    ranges = info.constraints |> Map.values |> List.flatten

    info.nearby
    |> List.flatten
    |> Enum.filter(fn value ->
      not Enum.any?(ranges, fn range -> value in range end)
    end)
    |> Enum.sum
  end
end
