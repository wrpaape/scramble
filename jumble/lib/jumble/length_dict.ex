defmodule Jumble.LengthDict do
  @dict File.read!("/usr/share/dict/words")

  def get(length_word) do
    __MODULE__
    |> Agent.get(Map, :get, [length_word])
  end

  def start_link(%{final_lengths: final_lengths, jumble_maps: jumble_maps} = args) do
    uniq_lengths =
      jumble_maps
      |> Enum.map(fn({_jumble, %{length: length}}) ->
        length
      end)
      |> Enum.into(final_lengths)
      |> Enum.uniq

    __MODULE__
    |> Agent.start_link(:build_dict, [uniq_lengths], name: __MODULE__)

    args
  end

  def build_dict(lengths) do
    lengths
    |> Enum.map_join("|",fn(length) ->
      length
      |> Integer.to_string
      |> Jumble.cap("\\w{", "}")
    end)
    |> Jumble.cap("\\b(", ")\\b")
    |> Regex.compile!
    |> Regex.scan(@dict, capture: :all_but_first)
    |> List.flatten
    |> Enum.group_by(&byte_size/1)
  end
end
