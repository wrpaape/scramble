defmodule Scramble do
  
  @dict "/usr/share/dict/words"
  |> File.read!

  def scan_by_length(len) do
    "\\b\\w{"
    <> Integer.to_string(len)
    <> "}\\b"
    |> Regex.compile!
    |> Regex.scan(@dict)
    |> Enum.with_index
    |> Enum.map_join("\n", fn({[word], index}) ->
      Integer.to_string(index) <> ". " <> word
    end)
    |> IO.puts
  end

  def complete(incomplete) do
    split_string =
      incomplete
      |> String.split

    ~r{(\s+)}
    |> Regex.replace(incomplete, fn(_cap, cap) ->
     "(\\w{" <> Integer.to_string(byte_size(cap)) <> "})" 
    end)
    |> Regex.compile!
    |> Regex.scan(@dict, capture: :all_but_first)
    |> Enum.map_join("\n", fn(blanks) ->
      split_string
      |> Enum.zip(blanks)
      |> Enum.map_join(fn({comp, blank}) ->
        comp <> IO.ANSI.red <> blank <> IO.ANSI.normal
      end)
    end)
  end
end
