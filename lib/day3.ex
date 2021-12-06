defmodule AdventCode.Day3 do
  def read_input do
    File.read!("inputs/input3")
    |> String.split()
    |> Enum.map(fn line ->
      line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1 do
    inputs = [first | _] = read_input()
    total_inputs = Enum.count(inputs)

    # Transpose matrix
    transposed =
      for i <- 0..(Enum.count(first) - 1), input <- inputs do
        Enum.at(input, i)
      end
      |> Enum.chunk_every(total_inputs)
      # Sum all 1
      |> Enum.map(&Enum.sum/1)

    # Note: Enum.frequencies exists -_-'

    gamma = compute(transposed, fn sum -> sum > div(total_inputs, 2) end)
    epsilon = compute(transposed, fn sum -> sum < div(total_inputs, 2) end)

    epsilon * gamma
  end

  def part2 do
    inputs = read_input()

    oxygen =
      compute_2(inputs, fn
        true -> 1
        false -> 0
      end)

    co2 =
      compute_2(inputs, fn
        true -> 0
        false -> 1
      end)

    oxygen * co2
  end

  def compute(data, fun_condition) do
    data
    |> Enum.map(fn sum ->
      case fun_condition.(sum) do
        true -> 1
        false -> 0
      end
    end)
    |> bin_to_int()
  end

  def compute_2(data, bit_condition) do
    digits = Enum.count(List.first(data))

    Enum.reduce_while(0..digits, data, fn i, acc ->
      total = Enum.count(acc)

      most_common =
        Enum.map(acc, fn input ->
          Enum.at(input, i)
        end)
        |> Enum.sum()
        |> (fn sum -> sum >= total / 2 end).()
        |> bit_condition.()

      case Enum.filter(acc, &(Enum.at(&1, i) == most_common)) do
        [final] -> {:halt, final}
        remaining -> {:cont, remaining}
      end
    end)
    |> bin_to_int()
  end

  # Manual binary to int using bit's position
  defp bin_to_int(bits) do
    bits |> Enum.join() |> String.to_integer(2)
    # bits
    # |> Enum.reverse()
    # |> Enum.with_index()
    # |> Enum.map(fn {bit, i} ->
    #   (:math.pow(2, i) * bit) |> round
    # end)
    # |> Enum.sum()
  end
end
