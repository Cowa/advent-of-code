defmodule AdventCode.Day7 do
  def read_input do
    crabs =
      File.read!("inputs/input7")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    range = Enum.min(crabs)..Enum.max(crabs)
    {crabs, range}
  end

  def part1 do
    {crabs, range} = read_input()

    for to_pos <- range do
      crabs
      |> Enum.map(&abs(&1 - to_pos))
      |> Enum.sum()
    end
    |> Enum.min()
  end

  def part2 do
    {crabs, range} = read_input()

    for to_pos <- range do
      crabs
      |> Enum.map(&Enum.sum(0..abs(&1 - to_pos)))
      |> Enum.sum()
    end
    |> Enum.min()
  end
end
