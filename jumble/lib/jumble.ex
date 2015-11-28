defmodule Jumble do
  alias Jumble.LengthDict
  alias IO.ANSI

  def solve(args = {final_lengths, jumbles_map}) do
    jumbles_map
    |> Enum.map_join("\n\n", fn({jumble, %{length: length, string_id: string_id, keys_at: keys_at}}) ->
      reg =
        length
        |> reg_keys(keys_at)

      jumble_sols =
        length
        |> LengthDict.get
        |> Enum.filter(fn(word) -> 
          string_id(word) == string_id
        end)
        |> Enum.with_index
        |> Enum.map_join("\n", fn({unjumbled, index}) ->
          {keys, color_coded}
            unjumbled
            |> color_code(reg)

          index + 1
          |> String.to_integer
          |> cap(pad(2), ". ")
        end)

      jumble
      |> cap(ANSI.white, "\n" <> jumble_sols)
    end)
  end

  # def color_code(solution, keys_at) do
  #   solution
  #   |> String.codepoints
  #   |> Enum.with_index
  #   |> Enum.reduce(ANSI.white, fn({letter, index}, acc) ->
  #     acc
  #     <> if index in keys_at, do: cap(letter, ANSI.red, ANSI.white), else: letter
  #   end)
  # end

  def reg_keys(length, keys_at) do
  # f = fn(length, keys_at) ->
    raw = 
      1..length
      |> Enum.map_join(fn(index) ->
        if index in keys_at, do: "(\\w)", else: "\\w"
      end)
    
    ~r/[^()]{4,}/
    |> Regex.replace(raw, fn(ws) ->
      ws
      |> byte_size
      |> div(2)
      |> Integer.to_string
      |> cap("\\w{", "}")
    end)
    |> Regex.compile!
  end

  def string_id(string) do
    string
    |> String.to_char_list
    |> Enum.sort
  end

  def cap(string, lcap, rcap), do: lcap <> string <> rcap
  def cap(string, cap),        do:  cap <> string <> cap

  def pad(pad_length), do: String.duplicate(" ", pad_length)
end