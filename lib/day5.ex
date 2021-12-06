defmodule AdventCode.Day5 do
  def read_input do
    File.read!("inputs/input5")
    |> String.replace(~r/ -> |\n/, ",")
    |> String.split(",")
    |> Enum.chunk_every(2)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [[x1, y1], [x2, y2]] ->
      [x1, y1, x2, y2] |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def part1 do
    read_input()
    |> Enum.filter(fn {x1, y1, x2, y2} ->
      x1 == x2 or y1 == y2
    end)
    |> Enum.flat_map(&range_coords/1)
    |> Enum.frequencies()
    |> Enum.filter(fn {_coord, freq} -> freq >= 2 end)
    |> Enum.count()
  end

  def part2 do
    read_input()
    |> Enum.flat_map(&range_coords/1)
    |> Enum.frequencies()
    |> Enum.filter(fn {_coord, freq} -> freq >= 2 end)
    |> Enum.count()
  end

  def range_coords({x, y1, x, y2}),
    do: Enum.to_list(y1..y2) |> Enum.map(&{x, &1})

  def range_coords({x1, y, x2, y}),
    do: Enum.to_list(x1..x2) |> Enum.map(&{&1, y})

  def range_coords({x1, y1, x2, y2}), do: Enum.zip(x1..x2, y1..y2)
end
