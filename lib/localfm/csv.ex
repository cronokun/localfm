defmodule LocalFM.CSV do
  @moduledoc """
  Module for converting entries from and to CSV.
  """

  def export(data, path) do
    output = File.stream!(path, [:write, :utf8])

    data
    |> Stream.map(&[&1.artist, &1.album, &1.track, &1.timestamp])
    |> CSV.encode()
    |> Stream.into(output)
    |> Stream.run()
  end
end
