defmodule LocalFM.EntryTest do
  use ExUnit.Case

  alias LocalFM.Entry

  test ".new/1 with proper timestamp" do
    attrs = %{
      "artist" => "Chicane",
      "album" => "Chilled Out Euphoria",
      "track" => "Overture",
      "timestamp" => "2024-04-24 15:38:45"
    }

    assert %Entry{
             artist: "Chicane",
             album: "Chilled Out Euphoria",
             track: "Overture",
             timestamp: ~N[2024-04-24 15:38:45]
           } == Entry.new(attrs)
  end

  test ".new/1 with formated timestamp" do
    attrs = %{
      "artist" => "Studio",
      "album" => "West Coast",
      "track" => "Self Service",
      "timestamp" => "18 Dec 2020 15:14"
    }

    assert %Entry{
             artist: "Studio",
             album: "West Coast",
             track: "Self Service",
             timestamp: ~N[2020-12-18 15:14:00]
           } == Entry.new(attrs)
  end
end
