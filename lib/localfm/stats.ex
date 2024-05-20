defmodule LocalFM.Stats do
  @type t :: %__MODULE__{
          date_range: LocalFM.DateRange.option(),
          last_played: [last_played_track],
          top_albums: [top_album_stat],
          top_artists: [top_artist_stat],
          top_tracks: [top_track_stat],
          totals: %{plays: pos_integer}
        }

  @typep artist_name :: String.t()
  @typep album_title :: String.t()
  @typep track_title :: String.t()
  @typep played_count :: pos_integer

  @typep top_album_stat :: {{artist_name, album_title}, played_count}
  @typep top_artist_stat :: {artist_name, played_count}
  @typep top_track_stat :: {{artist_name, album_title, track_title}, played_count}
  @typep last_played_track :: {{artist_name, album_title, track_title}, NaiveDateTime.t()}

  defstruct date_range: {:all_time, nil},
            last_played: [],
            top_albums: [],
            top_artists: [],
            top_tracks: [],
            totals: %{plays: 0, artists: 0, albums: 0}

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
      |> put_totals(data, range)

    {:ok, stats}
  end

  defp put_top_albums(stats, data, range, limit) do
    top_albums = process_data(data, range, limit, fn t -> {t.album_artist, t.album} end)

    Map.put(stats, :top_albums, top_albums)
  end

  defp put_top_artists(stats, data, range, limit) do
    top_artists = process_data(data, range, limit, fn t -> t.album_artist end)

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

  defp put_totals(stats, data, in_range) do
    init = {{0, 0, 0}, MapSet.new(), MapSet.new()}

    {{a, b, c}, _, _} =
      Enum.reduce(data, init, fn e, {{a, b, c}, artists, albums} = acc ->
        if in_range.(e) do
          new_album = not MapSet.member?(albums, {e.album_artist, e.album})
          new_artist = not MapSet.member?(artists, e.album_artist)

          case {new_artist, new_album} do
            {true, true} ->
              artists = MapSet.put(artists, e.album_artist)
              albums = MapSet.put(albums, {e.album_artist, e.album})
              {{a + 1, b + 1, c + 1}, artists, albums}

            {false, true} ->
              albums = MapSet.put(albums, {e.album_artist, e.album})
              {{a + 1, b, c + 1}, artists, albums}

            {false, false} ->
              {{a + 1, b, c}, artists, albums}
          end
        else
          acc
        end
      end)

    %{stats | totals: %{plays: a, artists: b, albums: c}}
  end

  defp process_data(data, range, limit, selector) do
    data
    |> Enum.filter(range)
    |> Enum.frequencies_by(selector)
    |> Enum.sort_by(fn {_, n} -> n end, :desc)
    |> Enum.take(limit)
  end

  defp put_date_range(stats, range), do: %{stats | date_range: range}
end
