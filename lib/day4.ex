defmodule AdventCode.Day4 do
  def read_input do
    [commands | grids] =
      File.read!("inputs/input4")
      |> String.split("\n\n")

    commands = String.split(commands, ",") |> Enum.map(&String.to_integer/1)

    grids =
      Enum.map(grids, fn g ->
        g
        |> String.split()
        # Marked as false
        |> Enum.map(&{String.to_integer(&1), false})
      end)

    {commands, grids}
  end

  def part1 do
    {commands, grids} = read_input()

    {winning_grid, last_cmd} =
      Enum.reduce_while(commands, grids, fn cmd, grids ->
        new_grids = Enum.map(grids, fn g -> mark_grid(g, cmd) end)

        case find_bingo(new_grids) do
          [] -> {:cont, new_grids}
          [bingo_grid] -> {:halt, {bingo_grid, cmd}}
        end
      end)

    Enum.reject(winning_grid, &elem(&1, 1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
    |> Kernel.*(last_cmd)
  end

  def part2 do
    {commands, grids} = read_input()

    {last_winning_grid, last_cmd} =
      Enum.reduce_while(commands, grids, fn cmd, grids ->
        new_grids = Enum.map(grids, fn g -> mark_grid(g, cmd) end)

        result = find_bingo(new_grids)

        cond do
          Enum.empty?(result) ->
            {:cont, new_grids}

          Enum.count(grids) == 1 ->
            {:halt, {hd(result), cmd}}

          true ->
            {:cont, new_grids -- result}
        end
      end)

    Enum.reject(last_winning_grid, &elem(&1, 1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
    |> Kernel.*(last_cmd)
  end

  defp mark_grid(grid, cmd) do
    Enum.map(grid, fn
      {^cmd, _} -> {cmd, true}
      cell -> cell
    end)
  end

  defp find_bingo(grids) do
    # Grids are 5x5
    Enum.filter(grids, fn grid ->
      rows = Enum.chunk_every(grid, 5)

      cols =
        for i <- 0..4 do
          Enum.take_every(Enum.drop(grid, i), 5)
        end

      Enum.any?(rows ++ cols, fn row_or_col -> Enum.all?(row_or_col, &elem(&1, 1)) end)
    end)
  end
end
