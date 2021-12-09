defmodule AdventCode.Day9 do
  def read_input do
    map =
      File.read!("inputs/input9")
      |> String.split()
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, x} ->
        String.split(row, "", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {pt, y} ->
          {{x, y}, String.to_integer(pt)}
        end)
      end)
      |> Map.new()

    rows = Enum.map(map, fn {{x, _}, _} -> x end) |> Enum.max()
    cols = Enum.map(map, fn {{_, y}, _} -> y end) |> Enum.max()

    {map, rows + 1, cols + 1}
  end

  def part1 do
    input = {map, _, _} = read_input()

    map
    |> Enum.filter(fn {coord, pt} ->
      Enum.all?(adjacents(input, coord) |> Enum.map(&elem(&1, 1)), &(pt < &1))
    end)
    |> Enum.map(fn {_coord, val} -> val + 1 end)
    |> Enum.sum()
  end

  def part2 do
    input = {map, _, _} = read_input()
    state = %{done: [], basins: []}

    map
    |> Enum.reject(&(elem(&1, 1) == 9))
    |> Enum.reduce(state, fn {coord, value}, acc = %{done: done, basins: basins} ->
      if {coord, value} in done do
        acc
      else
        basin = rec_adjacents(input, {coord, value}) |> Enum.uniq()
        %{acc | done: done ++ basin, basins: basins ++ [basin]}
      end
    end)
    |> Map.get(:basins)
    |> Enum.map(&length/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn el, acc -> el * acc end)
  end

  defp adjacents({map, rows, cols}, {x, y}) do
    left = if y !== 0, do: {x, y - 1}
    right = if y !== cols - 1, do: {x, y + 1}
    top = if x !== 0, do: {x - 1, y}
    down = if x !== rows - 1, do: {x + 1, y}

    [left, right, top, down]
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn coord -> {coord, Map.get(map, coord)} end)
  end

  defp rec_adjacents(input, _, done \\ [])

  defp rec_adjacents(_input, {_coord, 9}, done) do
    Enum.drop(done, -1)
  end

  defp rec_adjacents(input, {coord, _value}, done) do
    if coord in done do
      Enum.drop(done, -1)
    else
      adjacents(input, coord)
      |> Enum.reject(&(&1 in done))
      |> Enum.reduce(done, fn el, acc ->
        rec_adjacents(input, el, acc ++ [el])
      end)
    end
  end
end
