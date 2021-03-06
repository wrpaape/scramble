defmodule Scramble do
  @reg_ws ~r{\s+}
  
  defp dict do
   "/usr/share/dict/words"
   |> File.read!
  end

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
    
    @reg_ws
    |> Regex.replace(incomplete, fn(cap0, _cap1) ->
     "(\\w{" <> Integer.to_string(byte_size(cap0)) <> "})" 
    end)
    |> cap("\\b", "(\\b)") 
    |> Regex.compile!
    |> Regex.scan(dict, capture: :all_but_first)
    |> Enum.map_join("\n", fn(blanks) ->
      split_string
      |> Enum.zip(blanks)
      |> Enum.map_join(fn({comp, blank}) ->
        IO.ANSI.white <> comp <> IO.ANSI.red <> blank
      end)
    end)
    |> IO.puts
  end

  defp cap(string, lcap, rcap), do: lcap <> string <> rcap
  defp cap(string, cap),        do: cap <> string <> cap

end
