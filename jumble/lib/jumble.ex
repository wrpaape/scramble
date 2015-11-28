defmodule Jumble do
  [:dict_codepoints, :dict_length]
  |> Enum.each(fn(attr) ->
    __MODULE__
    |> Module.register_attribute(attr, persist: true)
  end)

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


  # def main([solution | jumbles]) do
  #   jumbles
  #   |> Enum.map(fn(jumble) ->
  #     jumble
  #     |> String.to_char_list
  #     |> Enum.reduce("\\b", fn(char, acc) ->
  #       [char]
  #     end)
  #   end)
  # end

  # def solve_jumble(jumble) do
    
  # end

  def test, do: [@dict_codepoints[~w(e h l l o)], @dict_length[10]]
end