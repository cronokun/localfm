defmodule LocalFM.StatsTest do
  use ExUnit.Case, async: true

  alias LocalFM.Entry
  alias LocalFM.Stats

  @default_opts %{limit: 10, date_range: {:all_time, nil}}

  @data [
    %Entry{
      artist: "Nicolas Jaar",
      album: "A Time For Us / Mi Mujer",
      track: "A Time For Us",
      timestamp: ~N[2023-08-08 12:00:00]
    },
    %Entry{
      artist: "Nicolas Jaar",
      album: "A Time For Us / Mi Mujer",
      track: "Mi Mujer",
      timestamp: ~N[2023-08-08 12:07:05]
    },
    %Entry{
      artist: "Burial",
      album: "Chemz / Dolphinz",
      track: "Chemz",
      timestamp: ~N[2023-08-08 13:00:00]
    },
    %Entry{
      artist: "Burial",
      album: "Chemz / Dolphinz",
      track: "Dolphinz",
      timestamp: ~N[2023-08-08 13:12:32]
    },
    %Entry{
      artist: "Kode9",
      album: "Infirmary / Unknown Summer",
      track: "Infirmary",
      timestamp: ~N[2023-08-08 14:00:00]
    },
    %Entry{
      artist: "Burial",
      album: "Infirmary / Unknown Summer",
      track: "Unknown Summer",
      timestamp: ~N[2023-08-08 14:05:40]
    },
    %Entry{
      artist: "Nicolas Jaar",
      album: "A Time For Us / Mi Mujer",
      track: "Mi Mujer",
      timestamp: ~N[2023-08-08 20:00:05]
    },
    %Entry{
      artist: "Burial",
      album: "Chemz / Dolphinz",
      track: "Chemz",
      timestamp: ~N[2023-08-08 13:00:00]
    },
    %Entry{
      artist: "Kode9",
      album: "Infirmary / Unknown Summer",
      track: "Infirmary",
      timestamp: ~N[2023-08-09 10:00:00]
    },
    %Entry{
      artist: "Burial",
      album: "Infirmary / Unknown Summer",
      track: "Unknown Summer",
      timestamp: ~N[2023-08-09 10:05:40]
    },
    %Entry{
      artist: "Nicolas Jaar",
      album: "A Time For Us / Mi Mujer",
      track: "Mi Mujer",
      timestamp: ~N[2023-08-09 17:00:00]
    }
  ]

  # FIXME: how to handle split albums? (Kode9 / Burial - Chemz / Dolphinz)
  test ".generate/2 calculates play statistics" do
    assert {:ok,
            %Stats{
              top_albums: [
                {{"Nicolas Jaar", "A Time For Us / Mi Mujer"}, 4},
                {{"Burial", "Chemz / Dolphinz"}, 3},
                {{"Burial", "Infirmary / Unknown Summer"}, 2},
                {{"Kode9", "Infirmary / Unknown Summer"}, 2}
              ],
              top_artists: [
                {"Burial", 5},
                {"Nicolas Jaar", 4},
                {"Kode9", 2}
              ],
              top_tracks: [
                {{"Nicolas Jaar", "A Time For Us / Mi Mujer", "Mi Mujer"}, 3},
                {{"Burial", "Chemz / Dolphinz", "Chemz"}, 2},
                {{"Burial", "Infirmary / Unknown Summer", "Unknown Summer"}, 2},
                {{"Kode9", "Infirmary / Unknown Summer", "Infirmary"}, 2},
                {{"Burial", "Chemz / Dolphinz", "Dolphinz"}, 1},
                {{"Nicolas Jaar", "A Time For Us / Mi Mujer", "A Time For Us"}, 1}
              ],
              last_played: [
                {{"Nicolas Jaar", "A Time For Us / Mi Mujer", "Mi Mujer"},
                 ~N[2023-08-09 17:00:00]},
                {{"Burial", "Infirmary / Unknown Summer", "Unknown Summer"},
                 ~N[2023-08-09 10:05:40]},
                {{"Kode9", "Infirmary / Unknown Summer", "Infirmary"}, ~N[2023-08-09 10:00:00]},
                {{"Burial", "Chemz / Dolphinz", "Chemz"}, ~N[2023-08-08 13:00:00]},
                {{"Nicolas Jaar", "A Time For Us / Mi Mujer", "Mi Mujer"},
                 ~N[2023-08-08 20:00:05]},
                {{"Burial", "Infirmary / Unknown Summer", "Unknown Summer"},
                 ~N[2023-08-08 14:05:40]},
                {{"Kode9", "Infirmary / Unknown Summer", "Infirmary"}, ~N[2023-08-08 14:00:00]},
                {{"Burial", "Chemz / Dolphinz", "Dolphinz"}, ~N[2023-08-08 13:12:32]},
                {{"Burial", "Chemz / Dolphinz", "Chemz"}, ~N[2023-08-08 13:00:00]},
                {{"Nicolas Jaar", "A Time For Us / Mi Mujer", "Mi Mujer"},
                 ~N[2023-08-08 12:07:05]}
              ],
              date_range: {:all_time, nil}
            }} = Stats.generate(@data, @default_opts)
  end

  @data [
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "25°C",
      timestamp: ~N[2022-08-09 14:00:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "0°C",
      timestamp: ~N[2022-08-09 14:05:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "17°C",
      timestamp: ~N[2022-08-09 14:10:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "14°C",
      timestamp: ~N[2022-08-09 14:15:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "2°C (Intermittent Rain)",
      timestamp: ~N[2022-08-09 14:20:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "10°C",
      timestamp: ~N[2022-08-09 14:25:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "6°C",
      timestamp: ~N[2022-08-09 14:30:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "4°C",
      timestamp: ~N[2022-08-09 14:35:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "30°C",
      timestamp: ~N[2022-08-09 14:40:00]
    },
    %Entry{
      artist: "Whatever the Weather",
      album: "Whatever the Weather",
      track: "36°C",
      timestamp: ~N[2022-08-09 14:45:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Fast Land",
      timestamp: ~N[2023-08-09 15:00:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Easy Prey",
      timestamp: ~N[2023-08-09 15:05:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Drum Glow",
      timestamp: ~N[2023-08-09 15:10:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Soft Edit",
      timestamp: ~N[2023-08-09 15:15:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Undo Redo",
      timestamp: ~N[2023-08-09 15:20:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Neon Rats",
      timestamp: ~N[2023-08-09 15:25:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "More Love",
      timestamp: ~N[2023-08-09 15:30:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Numb Bell",
      timestamp: ~N[2023-08-09 15:35:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Doom Hype",
      timestamp: ~N[2023-08-09 15:40:00]
    },
    %Entry{
      artist: "Moderat",
      album: "MORE D4TA",
      track: "Copy Copy",
      timestamp: ~N[2023-08-09 15:45:00]
    }
  ]

  test ".generate/2 groups tracks by artist/album" do
    assert {:ok,
            %Stats{
              top_albums: [
                {{"Moderat", "MORE D4TA"}, 10},
                {{"Whatever the Weather", "Whatever the Weather"}, 10}
              ],
              top_artists: [
                {"Moderat", 10},
                {"Whatever the Weather", 10}
              ],
              top_tracks: [
                {{"Moderat", "MORE D4TA", "Copy Copy"}, 1},
                {{"Moderat", "MORE D4TA", "Doom Hype"}, 1},
                {{"Moderat", "MORE D4TA", "Drum Glow"}, 1},
                {{"Moderat", "MORE D4TA", "Easy Prey"}, 1},
                {{"Moderat", "MORE D4TA", "Fast Land"}, 1},
                {{"Moderat", "MORE D4TA", "More Love"}, 1},
                {{"Moderat", "MORE D4TA", "Neon Rats"}, 1},
                {{"Moderat", "MORE D4TA", "Numb Bell"}, 1},
                {{"Moderat", "MORE D4TA", "Soft Edit"}, 1},
                {{"Moderat", "MORE D4TA", "Undo Redo"}, 1}
              ],
              last_played: [
                {{"Moderat", "MORE D4TA", "Copy Copy"}, ~N[2023-08-09 15:45:00]},
                {{"Moderat", "MORE D4TA", "Doom Hype"}, ~N[2023-08-09 15:40:00]},
                {{"Moderat", "MORE D4TA", "Numb Bell"}, ~N[2023-08-09 15:35:00]},
                {{"Moderat", "MORE D4TA", "More Love"}, ~N[2023-08-09 15:30:00]},
                {{"Moderat", "MORE D4TA", "Neon Rats"}, ~N[2023-08-09 15:25:00]},
                {{"Moderat", "MORE D4TA", "Undo Redo"}, ~N[2023-08-09 15:20:00]},
                {{"Moderat", "MORE D4TA", "Soft Edit"}, ~N[2023-08-09 15:15:00]},
                {{"Moderat", "MORE D4TA", "Drum Glow"}, ~N[2023-08-09 15:10:00]},
                {{"Moderat", "MORE D4TA", "Easy Prey"}, ~N[2023-08-09 15:05:00]},
                {{"Moderat", "MORE D4TA", "Fast Land"}, ~N[2023-08-09 15:00:00]}
              ],
              date_range: {:all_time, nil}
            }} = Stats.generate(@data, @default_opts)
  end

  @data [
    %Entry{
      artist: "Gorillaz feat. Thundercat",
      album: "Cracker Island",
      track: "Cracker Island",
      timestamp: ~N[2023-08-09 17:30:00]
    },
    %Entry{
      artist: "Gorillaz feat. Stevie Nicks",
      album: "Cracker Island",
      track: "Oil",
      timestamp: ~N[2023-08-09 17:31:00]
    },
    %Entry{
      artist: "Gorillaz",
      album: "Cracker Island",
      track: "The Tired Influencer",
      timestamp: ~N[2023-08-09 17:32:00]
    },
    %Entry{
      artist: "Gorillaz feat. Adeleye Omotayo",
      album: "Cracker Island",
      track: "Silent Running",
      timestamp: ~N[2023-08-09 17:33:00]
    },
    %Entry{
      artist: "Gorillaz feat. Tame Impala & Bootie Brown",
      album: "Cracker Island",
      track: "New Gold",
      timestamp: ~N[2023-08-09 17:34:00]
    },
    %Entry{
      artist: "Gorillaz",
      album: "Cracker Island",
      track: "Baby Queen",
      timestamp: ~N[2023-08-09 17:35:00]
    },
    %Entry{
      artist: "Gorillaz",
      album: "Cracker Island",
      track: "Tarantula",
      timestamp: ~N[2023-08-09 17:36:00]
    },
    %Entry{
      artist: "Gorillaz feat. Bad Bunny",
      album: "Cracker Island",
      track: "Tormenta",
      timestamp: ~N[2023-08-09 17:37:00]
    },
    %Entry{
      artist: "Gorillaz",
      album: "Cracker Island",
      track: "Skinny Ape",
      timestamp: ~N[2023-08-09 17:38:00]
    },
    %Entry{
      artist: "Gorillaz feat. Beck",
      album: "Cracker Island",
      track: "Possession Island",
      timestamp: ~N[2023-08-09 17:39:00]
    }
  ]

  test ".generate/2 groups tracks by album artist" do
    assert {:ok,
            %Stats{
              top_artists: [
                {"Gorillaz", 10}
              ],
              top_albums: [
                {{"Gorillaz", "Cracker Island"}, 10}
              ]
            }} = Stats.generate(@data, @default_opts)
  end

  @data [
    %Entry{artist: "Foo", album: "A1", track: "untitled", timestamp: ~N[2023-08-09 19:00:00]},
    %Entry{artist: "Foo", album: "A1", track: "untitled", timestamp: ~N[2023-08-09 19:00:01]},
    %Entry{artist: "Foo", album: "A1", track: "untitled", timestamp: ~N[2023-08-09 19:00:02]},
    %Entry{artist: "Bar", album: "B1", track: "untitled", timestamp: ~N[2023-08-09 19:00:03]},
    %Entry{artist: "Bar", album: "B1", track: "untitled", timestamp: ~N[2023-08-09 19:00:04]},
    %Entry{artist: "Bar", album: "B2", track: "untitled", timestamp: ~N[2023-08-09 19:00:05]},
    %Entry{artist: "Car", album: "C1", track: "untitled", timestamp: ~N[2023-08-09 19:00:06]},
    %Entry{artist: "Car", album: "C1", track: "untitled", timestamp: ~N[2023-08-09 19:00:07]},
    %Entry{artist: "Car", album: "C1", track: "untitled", timestamp: ~N[2023-08-09 19:00:08]},
    %Entry{artist: "Der", album: "D1", track: "untitled", timestamp: ~N[2023-08-09 19:00:09]},
    %Entry{artist: "Der", album: "D1", track: "untitled", timestamp: ~N[2023-08-09 19:00:10]}
  ]

  test ".generate/2 limits top N artists/albums/tracks" do
    assert {:ok,
            %Stats{
              top_artists: [
                {"Bar", 3},
                {"Car", 3},
                {"Foo", 3}
              ],
              top_albums: [
                {{"Car", "C1"}, 3},
                {{"Foo", "A1"}, 3},
                {{"Bar", "B1"}, 2}
              ],
              top_tracks: [
                {{"Car", "C1", "untitled"}, 3},
                {{"Foo", "A1", "untitled"}, 3},
                {{"Bar", "B1", "untitled"}, 2}
              ],
              last_played: [
                {{"Der", "D1", "untitled"}, ~N[2023-08-09 19:00:10]},
                {{"Der", "D1", "untitled"}, ~N[2023-08-09 19:00:09]},
                {{"Car", "C1", "untitled"}, ~N[2023-08-09 19:00:08]}
              ]
            }} = Stats.generate(@data, %{limit: 3, date_range: {:all_time, nil}})
  end

  test ".generate/2 filters artists/albums/tracks by date range" do
    now = NaiveDateTime.utc_now()
    this_month = NaiveDateTime.add(now, -29, :day)
    past_month = NaiveDateTime.add(now, -31, :day)

    data = [
      %Entry{artist: "Foo", album: "A1", track: "untitled", timestamp: past_month},
      %Entry{artist: "Foo", album: "A1", track: "untitled", timestamp: past_month},
      %Entry{artist: "Foo", album: "A1", track: "untitled", timestamp: past_month},
      %Entry{artist: "Bar", album: "B1", track: "untitled", timestamp: past_month},
      %Entry{artist: "Bar", album: "B1", track: "untitled", timestamp: past_month},
      %Entry{artist: "Bar", album: "B2", track: "untitled", timestamp: past_month},
      %Entry{artist: "Car", album: "C1", track: "untitled", timestamp: this_month},
      %Entry{artist: "Car", album: "C1", track: "untitled", timestamp: this_month},
      %Entry{artist: "Car", album: "C1", track: "untitled", timestamp: this_month},
      %Entry{artist: "Der", album: "D1", track: "untitled", timestamp: this_month},
      %Entry{artist: "Der", album: "D1", track: "untitled", timestamp: now}
    ]

    assert {:ok,
            %Stats{
              top_artists: [
                {"Car", 3},
                {"Der", 2}
              ],
              top_albums: [
                {{"Car", "C1"}, 3},
                {{"Der", "D1"}, 2}
              ],
              top_tracks: [
                {{"Car", "C1", "untitled"}, 3},
                {{"Der", "D1", "untitled"}, 2}
              ],
              last_played: [
                {{"Der", "D1", "untitled"}, ^now},
                {{"Der", "D1", "untitled"}, ^this_month},
                {{"Car", "C1", "untitled"}, ^this_month},
                {{"Car", "C1", "untitled"}, ^this_month},
                {{"Car", "C1", "untitled"}, ^this_month}
              ]
            }} = Stats.generate(data, %{limit: 10, date_range: {:last_n_days, 30}})
  end
end
