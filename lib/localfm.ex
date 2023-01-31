defmodule LocalFM do

  defmodule Entry do
    defstruct [:artist, :album, :track, :timestamp]

    def new(attrs) do
      %__MODULE__{
        album: attrs["album"],
        artist: attrs["artist"],
        track: attrs["track"],
        timestamp: timestamp_to_datetime(attrs["timestamp"])
      }
    end

    defp timestamp_to_datetime(string) do
      {:ok, timestamp, 0} = DateTime.from_iso8601(string <> ":00Z")
      timestamp
    end 
  end

  @curl_bin "/opt/homebrew/opt/curl/bin/curl"
  @creds "pi:moodeaudio"
  @source_url "sftp://moode.local/var/local/www/playhistory.log"

  def retrieve_data do
    System.cmd(@curl_bin, ["--insecure", "--silent", "--user", @creds, @source_url])
    |> case do
      {data, 0} -> {:ok, data}
      {_, error_code} -> {:error, "Something went wrong (#{error_code})"}
    end
  end

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

  @regex ~r[(?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}).+</a>(?<track>.+)</div><span>(?<album>.+)</span></li>]

  defp convert_line("<li" <> _rest = line) do
    captures = Regex.named_captures(@regex, line)
    [artist, album] = String.split(captures["album"], " - ")
    Map.merge(captures, %{"artist" => artist, "album" => album})
  end

  defp convert_line(_other), do: nil
end
