defmodule Jumble.CLI do
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

  def process([final | jumbles]) do
    IO.inspect :timer.tc(IO, :inspect, [%Dict{}.length])
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      {[help: true], _, _ } -> :help
      
      {_, [], _}            -> :help

      {_, [_one_arg | []], _}            -> :help
      
      {_, argv, _}          -> argv
    end
  end
end