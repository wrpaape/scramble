defmodule Jumble.LengthDict do
  @dict File.read!("/usr/share/dict/words")

  def get(key) do
    __MODULE__
    |> Agent.get(Map, :get, [key])
  end

  def take(keys) do
    __MODULE__
    |> Agent.get(Map, :take, [keys])
  end

  def start_link(args = {final_lengths, jumbles_map}) do
    # length_map =
    #   final_lengths
    #   |> scan_dict
    #   |> Enum.group_by(fn([word]) ->
    #     word
    #     |> byte_size
    #   end)

    # codepoints_map =
    #   jumbles_map
    #   |> Enum.map(fn({jumble, _key_pos}) ->
    #     jumble
    #     |> byte_size
    #   end)
    #   |> scan_dict
    #   |> Enum.group_by(fn([word]) ->
    #     word
    #     |> Jumble.codepoints_key
    #   end)
    
      uniq_lengths = jumbles_map
        |> Enum.map(fn({_jumble, %{length: length}}) ->
          length
        end)
        |> Enum.into(final_lengths)
        |> Enum.uniq

  

    __MODULE__
    |> Agent.start_link(:build_dict, [uniq_lengths], name: __MODULE__)

    args
  end

  defp build_dict(lengths) do
    lengths
    |> Enum.map_join("|",fn(length) ->
      length
      |> Integer.to_string
      |> Jumble.cap("\\w{", "}")
    end)
    |> Jumble.cap("\\b(", ")\\b")
    |> Regex.compile!
    |> Regex.scan(@dict, capture: :all_but_first)
    |> Enum.group_by(fn([word]) ->
      word
      |> byte_size
    end)
  end
end
