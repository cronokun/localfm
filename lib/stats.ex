defmodule LocalFM.Stats do
  defstruct [:top_albums, :top_artists, :top_tracks]

  def generate(data) do
    stats =
      %__MODULE__{}
      |> put_top_albums(data)
      |> put_top_artists(data)
      |> put_top_tracks(data)

    {:ok, stats}
  end

  defp put_top_albums(stats, data) do
    top_albums =
      data
      |> Enum.frequencies_by(fn t -> {album_artist(t), t.album} end)
      |> Enum.sort_by(fn {_, n} -> n end, :desc)
      |> Enum.take(10)

    Map.put(stats, :top_albums, top_albums)
  end

  defp put_top_artists(stats, data) do
    top_artists =
      data
      |> Enum.frequencies_by(fn t -> album_artist(t) end)
      |> Enum.sort_by(fn {_, n} -> n end, :desc)
      |> Enum.take(10)

    Map.put(stats, :top_artists, top_artists)
  end

  defp album_artist(entry) do
    if compilation?(entry.album) do
      "Various Artists"
    else
      entry.artist |> String.split(" feat. ") |> List.first()
    end
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

  defp put_top_tracks(stats, data) do
    top_tracks =
      data
      |> Enum.frequencies_by(fn t -> {t.artist, t.album, t.track} end)
      |> Enum.sort_by(fn {_, n} -> n end, :desc)
      |> Enum.take(10)

    Map.put(stats, :top_tracks, top_tracks)
  end
end
