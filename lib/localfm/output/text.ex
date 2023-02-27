defmodule LocalFM.Output.Text do
  import String, only: [pad_leading: 2, pad_trailing: 2]

  @number_padding 4
  @entry_padding 65
  @count_padding 10
  @total_padding 80

  def print(%LocalFM.Stats{} = stats) do
    date_range = date_range_to_s(stats.date_range)

    IO.puts([
      format_section_header("Top Artists", date_range),
      format_artists_list(stats.top_artists),
      format_section_header("Top Albums", date_range),
      format_albums_list(stats.top_albums),
      format_section_header("Top Tracks", date_range),
      format_tracks_list(stats.top_tracks)
    ])
  end

  defp format_section_header(header, date_range) do
    pad_length = @total_padding - String.length(header) - String.length(date_range)
    padding = String.duplicate(" ", pad_length)
    section_header = header <> padding <> date_range
    underline = String.replace(section_header, ~r/./,"_")

    [
      "\n",
      section_header,
      "\n",
      underline,
      "\n\n"
    ]
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

  defp date_range_to_s(:all_time), do: "All time"
  defp date_range_to_s(:last_7_days), do: "Last 7 days"
  defp date_range_to_s(:last_30_days), do: "Last 30 days"
  defp date_range_to_s(:last_90_days), do: "Last 90 days"
  defp date_range_to_s(:last_180_days), do: "Last 180 days"
  defp date_range_to_s(:last_365_days), do: "Last 365 days"
end
