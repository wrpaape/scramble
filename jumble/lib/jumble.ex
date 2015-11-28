defmodule Jumble do
  alias Jumble.Solver
  alias Jumble.LengthDict
  alias IO.ANSI

  @major_spacer "\n\n" <> ANSI.white
  @minor_spacer "\n  " <> ANSI.green

  def solve(%{jumble_maps: jumble_maps}) do
    jumbles = 
      jumble_maps
      |> Enum.map_join(@major_spacer, fn({jumble, %{length: length, string_id: string_id, keys_at: keys_at}}) ->
        reg =
          length
          |> reg_key_letters(keys_at)

        unjumbled_rows =
          length
          |> LengthDict.get
          |> Enum.filter(fn(word) -> 
            string_id(word) == string_id
          end)
          |> Enum.with_index
          |> Enum.map_join(@minor_spacer, fn({unjumbled, index}) ->
            jumble
            |> unjumbled_row(unjumbled, index + 1, reg)
          end)

        @minor_spacer
        |> cap(jumble, unjumbled_rows)
      end)

    @major_spacer
    |> cap("JUMBLES:", jumbles)
    |> IO.puts
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

  def unjumbled_row(jumble, unjumbled, row_index, reg) do
    key_letters =
      reg
      |> Regex.run(unjumbled, capture: :all_but_first)

    jumble
    |> Solver.push_unjumbled(unjumbled, key_letters)

    color_coded = 
      reg
      |> Regex.split(unjumbled, on: :all_but_first)
      |> color_code(key_letters)

    ". "
    |> cap(Integer.to_string(row_index), color_coded)
  end

  def color_code([excess_head | excess_rest], key_letters) do
    key_letters
    |> Enum.zip(excess_rest)
    |> Enum.reduce(ANSI.white <> excess_head, fn({key, excess}, acc) ->
      key
      |> cap(ANSI.red, ANSI.white)
      |> cap(acc, excess)
    end)
  end

  def reg_key_letters(length, keys_at) do
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