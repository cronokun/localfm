defmodule LocalFM.Stats do
  defstruct [:top_albums, :top_artists, :top_tracks, :date_range]

  def generate(data, opts) do
    range = LocalFM.DateRange.choose(opts.date_range)

    stats =
      %__MODULE__{}
      |> put_date_range(opts.date_range)
      |> put_top_albums(data, range, opts.limit)
      |> put_top_artists(data, range, opts.limit)
      |> put_top_tracks(data, range, opts.limit)

    {:ok, stats}
  end

  defp put_top_albums(stats, data, range, limit) do
    top_albums = process_data(data, range, limit, fn t -> {album_artist(t), t.album} end)

    Map.put(stats, :top_albums, top_albums)
  end

  defp put_top_artists(stats, data, range, limit) do
    top_artists = process_data(data, range, limit, fn t -> song_artist(t) end)

    Map.put(stats, :top_artists, top_artists)
  end

  defp put_top_tracks(stats, data, range, limit) do
    top_tracks = process_data(data, range, limit, fn t -> {t.artist, t.album, t.track} end)

    Map.put(stats, :top_tracks, top_tracks)
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
    ~r/latenightales/iu,
    ~r/pop ambient/iu,
    ~r/cafe del mar/iu,
    ~r/hotel costes/iu
  ]

  defp compilation?(album) do
    Enum.any?(@comp_regexes, fn reg -> String.match?(album, reg) end)
  end

  defp put_date_range(stats, date_range), do: Map.put(stats, :date_range, date_range)
end
