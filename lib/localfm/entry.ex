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
      timestamp: parse_timestamp(attrs["timestamp"])
    }
  end

  @months %{
    "Jan" => "01",
    "Feb" => "02",
    "Mar" => "03",
    "Apr" => "04",
    "May" => "05",
    "Jun" => "06",
    "Jul" => "07",
    "Aug" => "08",
    "Sep" => "09",
    "Oct" => "10",
    "Nov" => "11",
    "Dec" => "12"
  }

  # Process different timestamp formats:
  # - good: 2023-08-03 12:40:00
  # - bad:  13 Dec 2020 17:12
  defp parse_timestamp(string) do
    {:ok, timestamp} =
      case String.split(string, " ") do
        [_date, _time] ->
          NaiveDateTime.from_iso8601(string)

        [day, mname, year, time] ->
          NaiveDateTime.from_iso8601("#{year}-#{@months[mname]}-#{day} #{time}:00")
      end

    timestamp
  end
end
