defmodule Jumble.Generate do
  # defmacro char_pools(jumble_maps) do
  #   {generators, do_clause} =
  #     jumble_maps
  #     |> Enum.reverse
  #     |> Enum.map_reduce({[], []}, fn({jumble, %{unjumbleds: unjumbleds}}, {keys_clause, values_clause}) ->
  #       unjumbled = jumble <> "_unjumbled"
  #       key_letters = jumble <> "_key_letters"

  #       keys_clause = 
  #         quote do: [unquote(unjumbled) | unquote(keys_clause)]

  #       values_clause =
  #         quote do: unquote(values_clause) ++ unquote(key_letters)
        
  #       {quote do: unquote({unjumbled, key_letters}) <- unquote(unjumbleds), }
  #     end)

  #   quote do
  #     for 

  #   end
  # end
end