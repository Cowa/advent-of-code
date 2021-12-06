defmodule AdventCode.Day2 do
  def read_input do
    File.read!("inputs/input2")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [action, amount] = String.split(line)
      {action, String.to_integer(amount)}
    end)
  end

  def part1 do
    {h, d} =
      read_input()
      |> Enum.reduce({0, 0}, fn
        {"forward", amount}, {h, d} -> {h + amount, d}
        {"down", amount}, {h, d} -> {h, d + amount}
        {"up", amount}, {h, d} -> {h, d - amount}
      end)

    h * d
  end

  def part2 do
    {h, d, _a} =
      read_input()
      |> Enum.reduce({0, 0, 0}, fn
        {"forward", amount}, {h, d, a} ->
          {h + amount, d + amount * a, a}

        {"down", amount}, {h, d, a} ->
          {h, d, a + amount}

        {"up", amount}, {h, d, a} ->
          {h, d, a - amount}
      end)

    h * d
  end
end
