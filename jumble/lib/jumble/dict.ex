defmodule Jumble.Dict do
  #  [:dict_codepoints, :dict_length]
  # |> Enum.each(fn(attr) ->
  #   __MODULE__
  #   |> Module.register_attribute(attr, persist: true)
  # end)
  @dict "/usr/share/dict/words"
    |> File.read!
    |> String.split
  
  @dict_codepoints @dict
  "/usr/share/dict/words"
    |> File.read!
    |> String.split
    |> Enum.group_by(fn(string) ->
      string
      |> String.codepoints
      |> Enum.sort
    end)

  @dict_length @dict
    |> Enum.group_by(fn(string) ->
      string
      |> String.length
    end)

  defstruct codepoints: @dict_codepoints, length: @dict_length 

  # def test, do: [@dict_codepoints[~w(e h l l o)], @dict_length[10]]
end
