defmodule Jumble do
  alias Jumble.Dict

  def solve(args = {final_lengths, jumbles_map}) do
    jumbles_map
    |> Enum.map(fn({jumble, key_pos}) ->
      jumble_sols =
        jumble
        |> string_id
        |> Dict.get

    end)
  end

  def string_id(string) do
    string
    |> String.codepoints
    |> Enum.sort
  end
end