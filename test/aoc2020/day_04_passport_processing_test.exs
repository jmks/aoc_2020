defmodule Aoc2020.Day04PassportProcessingTest do
  use ExUnit.Case, async: true

  import Aoc2020.Day04PassportProcessing

  @invalid """
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  """

  @valid """
  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm
  """

  @raw """
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
"""

  test "parse" do
    assert parse(@invalid) == %{
      "ecl" => "gry",
      "pid" => "860033327",
      "eyr" => "2020",
      "hcl" => "#fffffd",
      "byr" => "1937",
      "iyr" => "2017",
      "cid" => "147",
      "hgt" => "183cm",
    }

    assert parse(@valid) == %{
      "hcl" => "#ae17e1",
      "iyr" => "2013",
      "eyr" => "2024",
      "ecl" => "brn",
      "pid" => "760753108",
      "byr" => "1931",
      "hgt" => "179cm",
    }
  end

  test "count valid" do
    assert count_valid_passports(@raw) == 2
  end

  test "solve part 1" do
    IO.puts("")
    IO.puts("Part 1: #{count_valid_passports(Input.raw(4))}")
  end
end
