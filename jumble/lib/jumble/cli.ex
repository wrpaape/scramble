defmodule Jumble.CLI do
  @parse_opts [switches: [ help: :boolean],
               aliases:  [ h:    :help   ]]

  alias Jumble.Solver
  alias Jumble.LengthDict

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
    |> Solver.start_link
    |> Jumble.solve
  end

  def parse_args(argv) do
    argv
    |> OptionParser.parse(@parse_opts)
    |> case do
      {[help: true], _, _ } -> :help
      
      {_, [], _}            -> :help

      {_, [_ | []], _}      -> :help
      
      {_, [clue_string | jumble_strings], _} ->
        {clue, final_lengths} =
          clue_string
          |> String.replace(~r{-}, " ")
          |> parse_arg_string

        jumble_maps =
          jumble_strings
          |> Enum.map(fn(jumble_string) ->
            {jumble, keys_at} =
              jumble_string
              |> parse_arg_string

            jumble_map =
              Map.new
              |> Map.put_new(:length, byte_size(jumble))
              |> Map.put_new(:string_id, Jumble.string_id(jumble))
              |> Map.put_new(:keys_at, keys_at)
              |> Map.put_new(:unjumbleds, [])

            {jumble, jumble_map}
          end)
        
        Map.new        
        |> Map.put_new(:clue, clue)
        |> Map.put_new(:final_lengths, final_lengths)
        |> Map.put_new(:jumble_maps, jumble_maps)
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