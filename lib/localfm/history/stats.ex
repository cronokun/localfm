defmodule LocalFM.History.Stats do
  @moduledoc """
  Generate statistics from play history (stored in database).
  """

  alias LocalFM.Repo
  alias LocalFM.History.Track

  import Ecto.Query

  def build(opts) do
    query = Track |> filter_by_date(opts)

    stats = %{
      top_albums: top_albums(query, opts),
      top_artists: top_artist(query, opts),
      top_tracks: top_tracks(query, opts),
      totals: select_totals(query),
      last_played: [],
      date_range: opts.date_range
    }

    {:ok, stats}
  end

  defp top_albums(query, opts) do
    query
    |> select([t], {{t.album_artist, t.album}, fragment("count(?) as plays", t.id)})
    |> group_by([t], [t.album_artist, t.album])
    |> select_top_n(opts)
    |> Repo.all()
  end

  defp top_artist(query, opts) do
    query
    |> select([t], {t.album_artist, fragment("count(?) as plays", t.id)})
    |> group_by([t], [t.album_artist])
    |> select_top_n(opts)
    |> Repo.all()
  end

  defp top_tracks(query, opts) do
    query
    |> select([t], {{t.artist, t.album, t.track}, fragment("count(?) as plays", t.id)})
    |> group_by([t], [t.artist, t.album, t.track])
    |> select_top_n(opts)
    |> Repo.all()
  end

  defp filter_by_date(query, opts) do
    case opts.date_range do
      {:all_time, nil} ->
        query

      {:by_year, year} ->
        query |> where([t], fragment("strftime('%Y', ?)", t.timestamp) == ^to_string(year))

      {:last_n_days, n} ->
        query |> where([t], t.timestamp >= date_add(^Date.utc_today(), ^(-n), "day"))
    end
  end

  defp select_top_n(query, opts) do
    query |> order_by(fragment("plays DESC, timestamp DESC")) |> limit(^opts.limit)
  end

  defp select_totals(_query) do
    %{
      plays: 0,
      artists: 0,
      albums: 0
    }
  end
end
