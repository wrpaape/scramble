defmodule Jumble.Helper do
  def string_id(string) do
    string
    |> String.to_char_list
    |> Enum.sort
  end

  def cap(string, lcap, rcap), do: lcap <> string <> rcap
  def cap(string, cap),        do:  cap <> string <> cap

  # def pad(pad_length), do: String.duplicate(" ", pad_length)

  def with_index(collection, initial) do
    Enum.map_reduce(collection, initial, fn(x, acc) ->
      {{x, acc}, acc + 1}
    end)
    |> elem(0)
  end
end