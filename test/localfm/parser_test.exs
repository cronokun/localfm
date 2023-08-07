defmodule LocalFM.ParserTest do
  use ExUnit.Case, async: true

  alias LocalFM.Entry
  alias LocalFM.Parser

  @input ~S"""
  <li class="playhistory-item"><div>2023-08-03 12:20<a href="http://www.google.com/search?q=Flying Lotus+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Golden Diva</div><span>Flying Lotus - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:24<a href="http://www.google.com/search?q=Flying Lotus+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Riot</div><span>Flying Lotus - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:28<a href="http://www.google.com/search?q=Flying Lotus+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>GNG BNG</div><span>Flying Lotus - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:32<a href="http://www.google.com/search?q=Flying Lotus+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Parisian Goldfish</div><span>Flying Lotus - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:35<a href="http://www.google.com/search?q=Flying Lotus+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Sleepy Dinosaur</div><span>Flying Lotus - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:37<a href="http://www.google.com/search?q=Flying Lotus feat. Dolly+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>RobertaFlack</div><span>Flying Lotus feat. Dolly - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:40<a href="http://www.google.com/search?q=Flying Lotus+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>SexSlaveShip</div><span>Flying Lotus - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:42<a href="http://www.google.com/search?q=Flying Lotus+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Auntie's Harp</div><span>Flying Lotus - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:43<a href="http://www.google.com/search?q=Flying Lotus feat. Gonja Sufi+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Testament</div><span>Flying Lotus feat. Gonja Sufi - Los Angeles</span></li>
  <li class="playhistory-item"><div>2023-08-03 12:45<a href="http://www.google.com/search?q=Flying Lotus feat. Laura Darlington+Los Angeles" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Auntie's Lock / Infinitum</div><span>Flying Lotus feat. Laura Darlington - Los Angeles</span></li>
  """

  @expected [
    %Entry{
      artist: "Flying Lotus",
      album: "Los Angeles",
      track: "Golden Diva",
      timestamp: ~N[2023-08-03 12:20:00]
    },
    %Entry{
      artist: "Flying Lotus",
      album: "Los Angeles",
      track: "Riot",
      timestamp: ~N[2023-08-03 12:24:00]
    },
    %Entry{
      artist: "Flying Lotus",
      album: "Los Angeles",
      track: "GNG BNG",
      timestamp: ~N[2023-08-03 12:28:00]
    },
    %Entry{
      artist: "Flying Lotus",
      album: "Los Angeles",
      track: "Parisian Goldfish",
      timestamp: ~N[2023-08-03 12:32:00]
    },
    %Entry{
      artist: "Flying Lotus",
      album: "Los Angeles",
      track: "Sleepy Dinosaur",
      timestamp: ~N[2023-08-03 12:35:00]
    },
    %Entry{
      artist: "Flying Lotus feat. Dolly",
      album: "Los Angeles",
      track: "RobertaFlack",
      timestamp: ~N[2023-08-03 12:37:00]
    },
    %Entry{
      artist: "Flying Lotus",
      album: "Los Angeles",
      track: "SexSlaveShip",
      timestamp: ~N[2023-08-03 12:40:00]
    },
    %Entry{
      artist: "Flying Lotus",
      album: "Los Angeles",
      track: "Auntie's Harp",
      timestamp: ~N[2023-08-03 12:42:00]
    },
    %Entry{
      artist: "Flying Lotus feat. Gonja Sufi",
      album: "Los Angeles",
      track: "Testament",
      timestamp: ~N[2023-08-03 12:43:00]
    },
    %Entry{
      artist: "Flying Lotus feat. Laura Darlington",
      album: "Los Angeles",
      track: "Auntie's Lock / Infinitum",
      timestamp: ~N[2023-08-03 12:45:00]
    }
  ]

  test ".parse/1 parses data from raw data" do
    assert {:ok, @expected} = Parser.parse(@input)
  end

  @input ~S"""
  <li class="playhistory-item"><div>2023-02-28 15:26<a href="http://www.google.com/search?q=David Holmes+π - Music For The Motion Picture" class="playhistory-link" target="_blank"><i class="fas fa-external-link-square"></i></a>No Man's Land</div><span>David Holmes - π - Music For The Motion Picture</span></li>
  """

  test ".parse/1 correctly handles dash in artist/album names" do
    assert {:ok,
            [
              %Entry{
                artist: "David Holmes",
                album: "π - Music For The Motion Picture",
                track: "No Man's Land",
                timestamp: ~N[2023-02-28 15:26:00]
              }
            ]} = Parser.parse(@input)
  end

  @input ~S"""
  Generated on 2000-01-01 bla-bla-bla
  <li class="playhistory-item"><div>2023-08-07 11:07<a href="http://www.google.com/search?q=Brian Eno+Thursday Afternoon" class="playhistory-link target-blank-link" target="_blank"><i class="fas fa-external-link-square"></i></a>Thursday Afternoon</div><span>Brian Eno - Thursday Afternoon</span></li>
  Lorem Ipsum
  """

  test ".parse/1 ignores non-<li> lines" do
    assert {:ok,
            [
              %Entry{
                artist: "Brian Eno",
                album: "Thursday Afternoon",
                track: "Thursday Afternoon",
                timestamp: ~N[2023-08-07 11:07:00]
              }
            ]} = Parser.parse(@input)
  end
end
