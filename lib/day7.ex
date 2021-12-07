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

    for crab <- crabs, to_pos <- range do
      {crab, to_pos, abs(crab - to_pos)}
    end
    |> min_fuel()
  end

  def part2 do
    {crabs, range} = read_input()

    for crab <- crabs, to_pos <- range do
      steps = abs(crab - to_pos)
      cost = Enum.sum(0..steps)

      {crab, to_pos, cost}
    end
    |> min_fuel()
  end

  defp min_fuel(cost_permutations) do
    cost_permutations
    |> Enum.group_by(&elem(&1, 1))
    |> Map.values()
    |> Enum.min_by(fn values ->
      values |> Enum.map(&elem(&1, 2)) |> Enum.sum()
    end)
    |> Enum.map(&elem(&1, 2))
    |> Enum.sum()
  end
end
