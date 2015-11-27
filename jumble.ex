defmodule Jumble do
  @dict "/usr/share/dict/words"
   |> File.read!
   |> String.split
   |> Enum.group_by(fn(string) ->
    string
    |> String.codepoints
    |> Enum.sort
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

  def solve do
    IO.inspect @dict    
  end
end