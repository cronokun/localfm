defmodule LocalFM.Entry do
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
    {:ok, timestamp} = NaiveDateTime.from_iso8601("#{string}:00")
    timestamp
  end 
end
