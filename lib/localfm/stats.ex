defmodule LocalFM.Stats do
  @type t :: %__MODULE__{
          top_albums: [top_album_stat],
          top_artists: [top_artist_stat],
          top_tracks: [top_track_stat],
          last_played: [last_played_track],
          date_range: LocalFM.DateRange.option()
        }

  @typep artist_name :: String.t()
  @typep album_title :: String.t()
  @typep track_title :: String.t()
  @typep played_count :: pos_integer

  @typep top_album_stat :: {{artist_name, album_title}, played_count}
  @typep top_artist_stat :: {artist_name, played_count}
  @typep top_track_stat :: {{artist_name, album_title, track_title}, played_count}
  @typep last_played_track :: {{artist_name, album_title, track_title}, NaiveDateTime.t()}

  defstruct [:top_albums, :top_artists, :top_tracks, :last_played, :date_range]

  @spec generate([LocalFM.Entry.t()], LocalFM.CLI.Config.t()) :: {:ok, t}
  def generate(data, opts) do
    range = LocalFM.DateRange.choose(opts.date_range)

    stats =
      %__MODULE__{}
      |> put_date_range(opts.date_range)
      |> put_top_albums(data, range, opts.limit)
      |> put_top_artists(data, range, opts.limit)
      |> put_top_tracks(data, range, opts.limit)
      |> put_last_played(data, range, opts.limit)

    {:ok, stats}
  end

  defp put_top_albums(stats, data, range, limit) do
    top_albums = process_data(data, range, limit, fn t -> {album_artist(t), t.album} end)

    Map.put(stats, :top_albums, top_albums)
  end

  defp put_top_artists(stats, data, range, limit) do
    top_artists = process_data(data, range, limit, fn t -> album_artist(t) end)

    Map.put(stats, :top_artists, top_artists)
  end

  defp put_top_tracks(stats, data, range, limit) do
    top_tracks = process_data(data, range, limit, fn t -> {t.artist, t.album, t.track} end)

    Map.put(stats, :top_tracks, top_tracks)
  end

  defp put_last_played(stats, data, range, limit) do
    last_played_tracks =
      data
      |> Enum.reverse()
      |> Enum.filter(range)
      |> Enum.take(limit)
      |> Enum.map(fn t -> {{t.artist, t.album, t.track}, t.timestamp} end)

    Map.put(stats, :last_played, last_played_tracks)
  end

  defp process_data(data, range, limit, selector) do
    data
    |> Enum.filter(range)
    |> Enum.frequencies_by(selector)
    |> Enum.sort_by(fn {_, n} -> n end, :desc)
    |> Enum.take(limit)
  end

  defp album_artist(entry) do
    if compilation?(entry.album) do
      "Various Artists"
    else
      song_artist(entry)
    end
  end

  defp song_artist(entry) do
    entry.artist |> String.split(" feat. ") |> List.first()
  end

  @comp_regexes [
    ~r/latenighttales/iu,
    ~r/pop ambient/iu,
    ~r/café del mar/iu,
    ~r/hotel costes/iu
  ]

  defp compilation?(album) do
    Enum.any?(@comp_regexes, fn reg -> String.match?(album, reg) end)
  end

  defp put_date_range(stats, date_range), do: Map.put(stats, :date_range, date_range)
end
