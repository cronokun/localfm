defmodule LocalFM.Output.TextTest do
  use ExUnit.Case, async: true

  alias LocalFM.Stats
  import LocalFM.Output.Text

  test ".render/1 renders last played tracks" do
    stats =
      build_stats()
      |> put_last_played({
        {"Boards of Canada", "In a Beautiful Place Out in the Country", "Kid for Today"},
        ~N[2024-01-21 10:14:36]
      })

    expected =
      "\n• Kid for Today — \e[1mBoards of Canada\e[0m" <>
        String.duplicate(" ", 47) <> "\e[3m21 Jan 2024, 10:14\e[0m\n"

    assert render(stats) =~ expected
  end

  test ".render/1 properly renders paddings" do
    stats =
      build_stats()
      |> put_last_played({
        {"Masashi Kitamura + Phonogenix",
         "Kankyō Ongaku (Japanese Ambient, Environmental & New Age Music 1980 - 1990)",
         "Variation・III"},
        ~N[2024-01-20 21:23:00]
      })
      |> put_last_played({
        {"DJ Krush", "未来 -Milight-", "時間の橋 1"},
        ~N[2024-01-21 10:57:30]
      })

    expected1 =
      "\n• Variation・III — \e[1mMasashi Kitamura + Phonogenix\e[0m" <>
        String.duplicate(" ", 33) <> "\e[3m20 Jan 2024, 21:23\e[0m\n"

    expected2 =
      "\n• 時間の橋 1 — \e[1mDJ Krush\e[0m" <>
        String.duplicate(" ", 58) <> "\e[3m21 Jan 2024, 10:57\e[0m\n"

    assert render(stats) =~ expected1
    assert render(stats) =~ expected2
  end

  defp build_stats do
    %Stats{
      top_albums: [],
      top_artists: [],
      top_tracks: [],
      last_played: [],
      date_range: :all_time
    }
  end

  defp put_last_played(stats, track), do: Map.update!(stats, :last_played, &[track | &1])
end
