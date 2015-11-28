defmodule Jumble.Dict do
  #  [:dict_codepoints, :dict_length]
  # |> Enum.each(fn(attr) ->
  #   __MODULE__
  #   |> Module.register_attribute(attr, persist: true)
  # end)
  @dict File.read!("/usr/share/dict/words")

  def scan_dict(lengths) do
    lengths
    |> Enum.uniq
    |> Enum.map_join("|",fn(length) ->
      length
      |> Integer.to_string
      |> cap("\\w{", "}")
    end)
    |> cap("\\b(", ")\\b")
  end


  def start_link([final_lengths | jumbles]) do
    length_map =
      final_lengths
      |> scan_dict
      |> Enum.group_by(&byte_size/1)

    codepoints_map =
      jumbles
      |> Enum.map(&byte_size/1)
      |> scan_dict
      |> Enum.group_by(fn(string) ->
        string
        |> String.codepoints
        |> Enum.sort
      end)

    Map
    |> Agent.start_link(:merge, [length_map, jumbles], name: __MODULE__)
  end

  defp cap(string, lcap, rcap), do: lcap <> string <> rcap
  defp cap(string, cap)         do: cap  <> string <> cap
end
