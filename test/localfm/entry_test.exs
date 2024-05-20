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
             album_artist: "Chicane",
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
             album_artist: "Studio",
             track: "Self Service",
             timestamp: ~N[2020-12-18 15:14:00]
           } == Entry.new(attrs)
  end

  test ".new/1 sets album artist" do
    attrs = %{
      "artist" => "Gorillaz feat. Stevie Nicks",
      "album" => "Cracker Island",
      "track" => "Oil",
      "timestamp" => "2023-08-09 17:31:00"
    }

    assert Entry.new(attrs).album_artist == "Gorillaz"
  end

  test ".new/1 sets album artist for compilations" do
    [
      %{
        "artist" => "A.R. Rahman",
        "album" => "Café del Mar vol. 5",
        "track" => "Mumbai Theme Tune",
        "timestamp" => "2024-05-20 19:10:00"
      },
      %{
        "artist" => "Doris Days",
        "album" => "Hôtel Costes 2",
        "track" => "To Ulrike M. (Zero 7 Mix)",
        "timestamp" => "2024-05-20 19:15:00"
      },
      %{
        "artist" => "Nina Simone",
        "album" => "LateNightTales: Bonobo",
        "track" => "Baltimore",
        "timestamp" => "2024-05-20 19:15:00"
      },
      %{
        "artist" => "T.Raumschmiere",
        "album" => "Pop Ambient 2024",
        "track" => "Eterna 2",
        "timestamp" => "2024-05-20 19:15:00"
      },
      %{
        "artist" => "Chet Baker",
        "album" => "Blue Note Trip vol. 6: Somethin' Old / Somethin' Blue",
        "track" => "That Old Feeling",
        "timestamp" => "2024-05-20 19:15:00"
      },
      %{
        "artist" => "Cody ChesnuTT",
        "album" => "DJ-Kicks",
        "track" => "Serve This Royalty",
        "timestamp" => "2024-05-20 19:15:00"
      },
      %{
        "artist" => "Metropolitan Jazz Affair",
        "album" => "Saint-Germain-des-Prés Café IV",
        "track" => "Yunowhathislifeez (Jazz Mix)",
        "timestamp" => "2024-05-20 19:15:00"
      }
    ]
    |> Enum.each(fn attrs ->
      assert Entry.new(attrs).album_artist == "Various Artists"
    end)
  end
end
