defmodule LocalFM.Parser do
  def parse(data) do
    {:ok, stream} = StringIO.open(data)

    entries =
      IO.binstream(stream, :line)
      |> Stream.map(&convert_line/1)
      |> Stream.reject(&is_nil/1)
      |> Stream.map(&LocalFM.Entry.new/1)
      |> Enum.to_list()

    {:ok, entries}
  end

  @regex ~r[(?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}).+</a>(?<track>.+)</div><span>(?<album>.+)</span></li>]

  defp convert_line("<li" <> _rest = line) do
    captures = Regex.named_captures(@regex, line)
    [artist, album] = String.split(captures["album"], " - ")
    Map.merge(captures, %{"artist" => artist, "album" => album})
  end

  defp convert_line(_other), do: nil
end
