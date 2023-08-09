defmodule Localfm.DateRangeTest do
  use ExUnit.Case, async: true

  alias LocalFM.DateRange
  alias LocalFM.Entry

  test ".choose/1 returns predicate function to filter entries by last N days" do
    data = [
      %Entry{artist: "Foo", album: "Bar", track: "track_1", timestamp: days_ago(1)},
      %Entry{artist: "Foo", album: "Bar", track: "track_2", timestamp: days_ago(7)},
      %Entry{artist: "Foo", album: "Bar", track: "track_3", timestamp: days_ago(8)},
      %Entry{artist: "Foo", album: "Bar", track: "track_4", timestamp: days_ago(30)},
      %Entry{artist: "Foo", album: "Bar", track: "track_5", timestamp: days_ago(31)},
      %Entry{artist: "Foo", album: "Bar", track: "track_6", timestamp: days_ago(90)},
      %Entry{artist: "Foo", album: "Bar", track: "track_7", timestamp: days_ago(91)},
      %Entry{artist: "Foo", album: "Bar", track: "track_8", timestamp: days_ago(180)},
      %Entry{artist: "Foo", album: "Bar", track: "track_9", timestamp: days_ago(365)},
      %Entry{artist: "Foo", album: "Bar", track: "track_10", timestamp: days_ago(366)}
    ]

    assert filter_entries(data, DateRange.choose(:last_7_days)) == ~w[track_1 track_2]

    assert filter_entries(data, DateRange.choose(:last_30_days)) ==
             ~w[track_1 track_2 track_3 track_4]

    assert filter_entries(data, DateRange.choose(:last_90_days)) ==
             ~w[track_1 track_2 track_3 track_4 track_5 track_6]

    assert filter_entries(data, DateRange.choose(:last_180_days)) ==
             ~w[track_1 track_2 track_3 track_4 track_5 track_6 track_7 track_8]

    assert filter_entries(data, DateRange.choose(:last_365_days)) ==
             ~w[track_1 track_2 track_3 track_4 track_5 track_6 track_7 track_8 track_9]

    assert filter_entries(data, DateRange.choose(:all_time)) ==
             ~w[track_1 track_2 track_3 track_4 track_5 track_6 track_7 track_8 track_9 track_10]
  end

  @now NaiveDateTime.utc_now()

  defp days_ago(n), do: NaiveDateTime.add(@now, -n, :day)

  defp filter_entries(data, fun), do: data |> Enum.filter(fun) |> Enum.map(& &1.track)
end
