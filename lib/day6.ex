defmodule AdventCode.Day6 do
  def read_input do
    File.read!("inputs/input6")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  def part1 do
    read_input()
    |> fish_count_after(80)
  end

  def part2 do
    read_input()
    |> fish_count_after(256)
  end

  def fish_count_after(fishes, days) do
    1..days
    |> Enum.reduce(fishes, fn _day, fishes ->
      update_fishes(fishes)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def update_fishes(fishes) do
    Enum.reduce(fishes, %{}, fn {day, fish_count}, acc ->
      acc = Map.update(acc, decrease_day(day), fish_count, &(&1 + fish_count))

      if day == 0, do: Map.put(acc, 8, fish_count), else: acc
    end)
  end

  def decrease_day(0), do: 6
  def decrease_day(d), do: d - 1
end
