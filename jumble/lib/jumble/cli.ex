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
    |> Dict.start_link
    |> Jumble.solve
  end

  def parse_args(argv) do
    argv
    |> OptionParser.parse(@parse_opts)
    |> case do
      {[help: true], _, _ } -> :help
      
      {_, [], _}            -> :help

      {_, [_ | []], _}      -> :help
      
      {_, [final_lengths_string | jumbles], _} ->
        final_lengths =
          final_lengths_string
          |> parse_ints

        jumbles_map =
          jumbles
          |> Enum.map(fn(jumble) ->
            [word, key_pos] =
              jumble
              |> String.split(~r{/}, parts: 2)

            {word, parse_ints(key_pos)}
          end)
          |> Enum.into(Map.new)

        {final_lengths, jumbles_map}
    end
  end

  def parse_ints(string) do
    string
    |> String.split(~r{/})
    |> Enum.map(&String.to_integer/1)
  end
end