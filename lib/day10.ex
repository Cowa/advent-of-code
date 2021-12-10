defmodule AdventCode.Day10 do
  @close [">", "}", "]", ")"]
  @points %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  def read_input do
    File.read!("inputs/input10")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def part1 do
    read_input()
    |> compute()
    |> Enum.filter(&is_tuple/1)
    |> Enum.map(&Map.get(@points, elem(&1, 1)))
    |> Enum.sum()
  end

  def part2 do
    candidates =
      read_input()
      |> compute()
      |> Enum.filter(&is_list/1)
      |> Enum.map(fn completion ->
        Enum.reduce(completion, 0, fn char, score ->
          5 * score + @points[char]
        end)
      end)
      |> Enum.sort()

    Enum.at(candidates, div(length(candidates), 2))
  end

  defp compute(lines) do
    Enum.map(lines, fn line ->
      line
      |> Enum.reduce_while(
        [],
        fn
          char, [acc | tail] when char in @close ->
            if acc == to_open(char),
              do: {:cont, tail},
              else: {:halt, {:corrupted, char}}

          char, acc ->
            {:cont, [char | acc]}
        end
      )
    end)
  end

  defp to_open(">"), do: "<"
  defp to_open(")"), do: "("
  defp to_open("}"), do: "{"
  defp to_open("]"), do: "["
end
