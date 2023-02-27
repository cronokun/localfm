defmodule LocalFM.Stats do
  defstruct [:top_albums, :top_artists, :top_tracks, :date_range]

  @limit 10

  def generate(data), do: generate(data, :all_time)

  def generate(data, date_range) do
    range = LocalFM.DateRange.choose(date_range)

    stats =
      %__MODULE__{}
      |> put_date_range(date_range)
      |> put_top_albums(data, range)
      |> put_top_artists(data, range)
      |> put_top_tracks(data, range)

    {:ok, stats}
  end

  defp put_top_albums(stats, data, range) do
    top_albums =
      data
      |> Enum.filter(range)
      |> Enum.frequencies_by(fn t -> {album_artist(t), t.album} end)
      |> Enum.sort_by(fn {_, n} -> n end, :desc)
      |> Enum.take(@limit)

    Map.put(stats, :top_albums, top_albums)
  end

  defp put_top_artists(stats, data, range) do
    top_artists =
      data
      |> Enum.filter(range)
      |> Enum.frequencies_by(fn t -> song_artist(t) end)
      |> Enum.sort_by(fn {_, n} -> n end, :desc)
      |> Enum.take(@limit)

    Map.put(stats, :top_artists, top_artists)
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

  defp put_top_tracks(stats, data, range) do
    top_tracks =
      data
      |> Enum.filter(range)
      |> Enum.frequencies_by(fn t -> {t.artist, t.album, t.track} end)
      |> Enum.sort_by(fn {_, n} -> n end, :desc)
      |> Enum.take(@limit)

    Map.put(stats, :top_tracks, top_tracks)
  end

  defp put_date_range(stats, date_range), do: Map.put(stats, :date_range, date_range)
end
