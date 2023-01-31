defmodule LocalFM.Output.Text do
  import String, only: [pad_leading: 2, pad_trailing: 2]

  @number_padding 4
  @entry_padding 65
  @count_padding 10

  def print(%LocalFM.Stats{} = stats) do
    [
      "\nTop Artists\n",
      "-----------\n\n",
      format_artists_list(stats.top_artists),
      "\nTop Albums\n",
      "----------\n\n",
      format_albums_list(stats.top_albums),
      "\nTop Tracks\n",
      "----------\n\n",
      format_tracks_list(stats.top_tracks)
    ]
    |> IO.puts()
  end

  defp format_albums_list(list) do
    list |> Enum.with_index(1) |> Enum.map(&format_album/1)
  end

  defp format_artists_list(list) do
    list |> Enum.with_index(1) |> Enum.map(&format_artist/1)
  end

  defp format_tracks_list(list) do
    list |> Enum.with_index(1) |> Enum.map(&format_track/1)
  end

  defp format_artist({{artist, count}, index}) do
    [
      pad_trailing("#{index}.", @number_padding),
      pad_trailing(artist, @entry_padding),
      " ",
      pad_leading("(#{play_or_plays(count)})\n", @count_padding)
    ]
  end

  defp format_album({{{artist, album}, count}, index}) do
    [
      pad_trailing("#{index}.", @number_padding),
      pad_trailing("\"#{album}\" by #{artist}", @entry_padding),
      " ",
      pad_leading("(#{play_or_plays(count)})\n", @count_padding)
    ]
  end

  def format_track({{{artist, _album, track}, count}, index}) do
    [
      pad_trailing("#{index}.", @number_padding),
      pad_trailing("\"#{track}\" by #{artist}", @entry_padding),
      " ",
      pad_leading("(#{play_or_plays(count)})\n", @count_padding)
    ]
  end

  defp play_or_plays(1), do: "1 play"
  defp play_or_plays(n), do: "#{n} plays"
end
