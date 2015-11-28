defmodule Jumble.CLI do
  @parse_opts [switches: [ help: :boolean],
               aliases:  [ h:    :help   ]]

  alias Jumble.Dict

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    """
    usage: jumble <final> <jumble0> <jumble1> ... <jumbleN>
    """
    |> IO.puts

    System.halt(0)
  end

  def process(args) do
    args
    |> LengthDict.start_link
    |> Jumble.solve
  end

  def parse_args(argv) do
    argv
    |> OptionParser.parse(@parse_opts)
    |> case do
      {[help: true], _, _ } -> :help
      
      {_, [], _}            -> :help

      {_, [_ | []], _}      -> :help
      
      {_, [clue_string | jumbles_string], _} ->
        {clue, final_lengths} =
          clue_string
          |> String.replace(~r{-}, " ")
          |> parse_arg_string

        jumbles_string
        |> Enum.map(fn(jumble) ->
          {word, keys_at} =
            jumble
            |> parse_arg_string

          jumble_map =
            Map.new
            |> Map.put_new(:length, byte_size(word))
            |> Map.put_new(:string_id, Jumble.string_id(word))
            |> Map.put_new(:keys_at, keys_at)

          {word, jumble_map}
        end)
        |> Enum.into(Map.new)
        |> Map.put_new(:clue, clue)
        |> Map.put_new(:final_lengths, final_lengths)
    end
  end

  def parse_arg_string(arg_string) do
    [arg, ints_string]
    string
    |> String.split(~r{/}, parts: 2)

    {arg, parse_ints(ints_string)}
  end

  def parse_ints(string) do
    string
    |> String.split(~r{/})
    |> Enum.map(&String.to_integer/1)
  end
end