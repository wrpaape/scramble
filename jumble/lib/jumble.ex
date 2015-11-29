defmodule Jumble do
  alias Jumble.Solver
  alias Jumble.LengthDict
  alias IO.ANSI

  @jumble_spacer    "\n\n" <> ANSI.white
  @unjumbled_spacer "\n  " <> ANSI.yellow
  @cc_spacer          ". " <> ANSI.red
  @header ANSI.underline <> ANSI.cyan <> "JUMBLES:\n" <> ANSI.no_underline <> ANSI.white

  def start(%{jumble_maps: jumble_maps}) do
    jumbles = 
      jumble_maps
      |> Enum.map_join(@jumble_spacer, fn({jumble, %{jumble_index: jumble_index, length: length, string_id: string_id, keys_at: keys_at}}) ->
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
          |> Enum.map_join(@unjumbled_spacer, fn({unjumbled, index}) ->
            jumble
            |> unjumbled_row(unjumbled, index + 1, reg)
          end)

        @unjumbled_spacer
        |> cap(jumble, unjumbled_rows)
        |> number_string(jumble_index, ". ")
      end)

    Solver.solve

    @header
    <> jumbles
    |> IO.puts
  end

  def unjumbled_row(jumble, unjumbled, unjumbled_index, reg) do
    key_letters =
      reg
      |> Regex.run(unjumbled, capture: :all_but_first)

    jumble
    |> Solver.push_unjumbled(unjumbled, key_letters)

    reg
    |> Regex.split(unjumbled, on: :all_but_first)
    |> color_code(key_letters)
    |> number_string(unjumbled_index, @cc_spacer)
  end

  def color_code([excess_head | excess_rest], key_letters) do
    key_letters
    |> Enum.zip(excess_rest)
    |> Enum.reduce(excess_head, fn({key, excess}, acc) ->
      key
      |> cap(ANSI.red, ANSI.green)
      |> cap(acc, excess)
    end)
  end

  def reg_key_letters(length, keys_at) do
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

  def number_string(string, index_string, spacer) do
    spacer
    |> cap(Integer.to_string(index_string), string)
  end

  def cap(string, lcap, rcap), do: lcap <> string <> rcap
  def cap(string, cap),        do:  cap <> string <> cap

  def pad(pad_length), do: String.duplicate(" ", pad_length)
end