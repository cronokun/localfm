defmodule LocalFM.Entry do
  defstruct [:artist, :album, :track, :timestamp]

  @type t :: %__MODULE__{
          artist: String.t(),
          album: String.t(),
          track: String.t(),
          timestamp: NaiveDateTime.t()
        }

  @typedoc "A map of raw entry data from the parser"
  @type raw_entry_data :: %{String.t() => String.t()}

  @spec new(raw_entry_data) :: t
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
