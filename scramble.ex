defmodule Scramble do
  
  @dict "/usr/share/dict/words"
  |> File.read!

  def by_length(len) do
    "(?<=\n)\\w{"
    <> Integer.to_string(len)
    <> "}(?=\n)"
    |> Regex.compile!
    |> Regex.scan(@dict)
    |> Enum.with_index
    |> Enum.map_join("\n", fn({[word], index}) ->
      Integer.to_string(index) <> ". " <> word
    end)
    |> IO.puts
  end

end
