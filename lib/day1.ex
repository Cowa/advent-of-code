defmodule AdventCode.Day1 do
  def read_input do
    File.read!("inputs/input") |> String.split() |> Enum.map(&String.to_integer/1)
  end

  def part1 do
    read_input() |> total_increase()
  end

  def part2 do
    read_input() |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1) |> total_increase()
  end

  defp total_increase(inputs) do
    Enum.reduce(inputs, {:infinity, 0}, fn
      input, {prev, acc} when input > prev -> {input, acc + 1}
      input, {_, acc} -> {input, acc}
    end)
    |> elem(1)
  end
end
