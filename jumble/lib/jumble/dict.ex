defmodule Jumble.Dict do
  @dict File.read!("/usr/share/dict/words")

  def get(key) do
    __MODULE__
    |> Agent.get(Map, :get, [key])
  end

  def start_link(args = {final_lengths, jumbles_map}) do
    length_map =
      final_lengths
      |> scan_dict
      |> Enum.group_by(fn([word]) ->
        word
        |> byte_size
      end)

    codepoints_map =
      jumbles_map
      |> Enum.map(fn({jumble, _key_pos}) ->
        jumble
        |> byte_size
      end)
      |> scan_dict
      |> Enum.group_by(fn([word]) ->
        word
        |> String.codepoints
        |> Enum.sort
      end)

    Map
    |> Agent.start_link(:merge, [length_map, codepoints_map], name: __MODULE__)

    args
  end

  defp scan_dict(lengths) do
    lengths
    |> Enum.uniq
    |> Enum.map_join("|",fn(length) ->
      length
      |> Integer.to_string
      |> cap("\\w{", "}")
    end)
    |> cap("\\b(", ")\\b")
    |> Regex.compile!
    |> Regex.scan(@dict, capture: :all_but_first)
  end

  defp cap(string, lcap, rcap), do: lcap <> string <> rcap
  # defp cap(string, cap),        do: cap  <> string <> cap
end
