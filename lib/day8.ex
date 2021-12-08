defmodule AdventCode.Day8 do
  @unique_wire_size [2, 3, 4, 7]

  def read_input do
    File.read!("inputs/input8")
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " | ")
      |> Enum.map(&String.split/1)
      |> Enum.map(fn wires ->
        Enum.map(wires, fn w ->
          String.codepoints(w) |> Enum.sort()
        end)
      end)
    end)
  end

  def part1 do
    read_input()
    |> Enum.map(fn [_input, output] ->
      Enum.count(output, &(length(&1) in @unique_wire_size))
    end)
    |> Enum.sum()
  end

  def part2 do
    read_input()
    |> Enum.map(fn [input, output] ->
      pattern = mapping_pattern(input, output)
      Enum.map(output, &digits(&1, pattern)) |> Enum.join() |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp mapping_pattern(input, output) do
    %{2 => [one], 3 => [seven], 4 => [four], 7 => [eight], 5 => five_length, 6 => six_length} =
      (input ++ output) |> Enum.uniq() |> Enum.group_by(&length/1)

    {[nine], six_length} = Enum.split_with(six_length, &contains_digits(&1, four))
    {[zero], [six]} = Enum.split_with(six_length, &contains_digits(&1, seven))
    {[three], five_length} = Enum.split_with(five_length, &contains_digits(&1, seven))
    {[five], [two]} = Enum.split_with(five_length, &contains_digits(six, &1))

    %{
      0 => zero,
      1 => one,
      2 => two,
      3 => three,
      4 => four,
      5 => five,
      6 => six,
      7 => seven,
      8 => eight,
      9 => nine
    }
  end

  defp contains_digits(o1, o2) do
    MapSet.new(o2) |> MapSet.subset?(MapSet.new(o1))
  end

  defp digits(output, patterns) do
    {digit, _} = Enum.find(patterns, &(elem(&1, 1) == output))
    "#{digit}"
  end
end
