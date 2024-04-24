defmodule LocalFM.Parser do
  alias LocalFM.Entry

  @typedoc ~S"""
  Raw history data. Multiline text containing some HTML markup, one `<li>` tag per track.
  """
  @type raw_history_data :: String.t()

  @spec parse(raw_history_data) :: {:ok, [Entry.t()]}
  def parse(data) do
    {:ok, stream} = StringIO.open(data)

    entries =
      IO.binstream(stream, :line)
      |> Stream.map(&convert_line/1)
      |> Stream.reject(&is_nil/1)
      |> Stream.map(&Entry.new/1)
      |> Enum.to_list()

    {:ok, entries}
  end

  @regex ~r[(?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}).+</a>(?<track>.+)</div><span>(?<artist>.+) - (?<album>.+)</span></li>]U

  defp convert_line("<li" <> _rest = line) do
    Regex.named_captures(@regex, line, capture: :all_but_first)
    |> Map.update("timestamp", nil, &(&1 <> ":00"))
  end

  defp convert_line(_other), do: nil
end
