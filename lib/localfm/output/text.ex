defmodule LocalFM.Output.Text do
  @index_padding 4
  @count_padding 6
  @total_padding 99

  def print(%LocalFM.Stats{} = stats), do: stats |> render() |> IO.puts()

  def render(%LocalFM.Stats{} = stats) do
    date_range = date_range_to_s(stats.date_range)

    IO.iodata_to_binary([
      "\n",
      format_section_header("Top Artists", date_range),
      format_list(stats.top_artists, &format_artist/1),
      format_section_header("Top Albums", date_range),
      format_list(stats.top_albums, &format_album/1),
      format_section_header("Top Tracks", date_range),
      format_list(stats.top_tracks, &format_track/1),
      format_section_header("Recently Played"),
      format_list(stats.last_played, &format_track_with_timestamp/1)
    ])
  end

  defp format_section_header(header) do
    section_header = (" " <> header <> " ") |> reverse_str()

    ["\n", section_header, "\n\n"]
  end

  defp format_section_header(header, date_range) do
    pad_length = @total_padding - printable_length(header) - printable_length(date_range) - 2
    padding = String.duplicate(" ", pad_length)
    section_header = (" " <> header <> " ") |> reverse_str()

    ["\n", section_header, padding, underline_str(date_range), "\n\n"]
  end

  defp format_list(list, format_fun) do
    list |> Enum.with_index(1) |> Enum.map(format_fun)
  end

  defp format_artist({{artist, count}, index}) do
    length = printable_length(artist)

    format_list_item(
      {artist, length},
      index,
      count
    )
  end

  defp format_album({{{artist, album}, count}, index}) do
    length = printable_length(artist) + printable_length(album) + 3

    format_list_item(
      {"#{album} — #{bold_str(artist)}", length},
      index,
      count
    )
  end

  def format_track({{{artist, _album, track}, count}, index}) do
    length = printable_length(artist) + printable_length(track) + 3

    format_list_item(
      {"#{track} — #{bold_str(artist)}", length},
      index,
      count
    )
  end

  def format_track_with_timestamp({{{artist, _album, track}, timestamp}, _index}) do
    str = "• #{track} — #{bold_str(artist)}"
    timestamp = Calendar.strftime(timestamp, "%d %b %Y, %H:%M")

    padding_length =
      @total_padding - printable_length(track) - printable_length(artist) -
        printable_length(timestamp) - 5

    [
      str,
      String.duplicate(" ", max(padding_length, 1)),
      italic_str(timestamp),
      "\n"
    ]
  end

  defp format_list_item({str, str_length}, index, count) do
    length = str_length + printable_length(to_string(count))

    [
      formated_index(index),
      str,
      padding(length),
      formated_play_count(count),
      "\n"
    ]
  end

  defp formated_index(index) do
    idx_str = index |> to_string() |> String.pad_leading(2)
    idx_str <> ". "
  end

  defp padding(length) do
    padding_length = max(@total_padding - @count_padding - @index_padding - length, 1)

    String.duplicate(" ", padding_length)
  end

  defp formated_play_count(count), do: "#{play_or_plays(count)}" |> italic_str()

  defp play_or_plays(1), do: "1 play"
  defp play_or_plays(n), do: "#{n} plays"

  defp date_range_to_s(:all_time), do: "All time"
  defp date_range_to_s(:last_7_days), do: "Last 7 days"
  defp date_range_to_s(:last_30_days), do: "Last 30 days"
  defp date_range_to_s(:last_90_days), do: "Last 90 days"
  defp date_range_to_s(:last_180_days), do: "Last 180 days"
  defp date_range_to_s(:last_365_days), do: "Last 365 days"

  defp bold_str(str) when is_binary(str), do: "\e[1m" <> str <> "\e[0m"
  defp italic_str(str) when is_binary(str), do: "\e[3m" <> str <> "\e[0m"
  defp underline_str(str) when is_binary(str), do: "\e[4m" <> str <> "\e[0m"
  defp reverse_str(str) when is_binary(str), do: "\e[1;7m" <> str <> "\e[0m"

  defp printable_length(str) do
    str
    |> String.codepoints()
    |> Enum.reduce(0, fn char, total ->
      case byte_size(char) do
        1 -> total + 1
        2 -> total + 1
        3 -> total + 2
      end
    end)
  end
end
