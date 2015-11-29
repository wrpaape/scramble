defmodule Jumble.Solver do
  # def get(key) do
  #   __MODULE__
  #   |> Agent.get(Map, :get, [key])
  # end
  # alias Jumble.Generate


  def solve do
    __MODULE__
    |> Agent.cast(&solve/1)
  end

  def push_unjumbled(jumble, unjumbled, key_letters) do
    push = fn(unjumbleds) ->
      [{unjumbled, key_letters} | unjumbleds]
    end

    __MODULE__
    |> Agent.cast(Kernel, :update_in, [[:jumble_maps, jumble, :unjumbleds], push])
  end

  def start_link(args) do
    into_map = fn(jumble_maps) ->
      jumble_maps
      |> Enum.into(Map.new)
    end

    Map
    |> Agent.start_link(:update!, [args, :jumble_maps, into_map], name: __MODULE__)

    args
  end


  def solve(%{clue: clue, final_lengths: final_lengths, jumble_maps: jumble_maps}) do
    jumble_maps
    |> IO.inspect
    # |> Generate.char_pools
  end
end