defmodule LocalFM.CSV do
  @moduledoc """
  Module for converting entries from and to CSV.
  """

  alias LocalFM.Entry

  def export(data, path) do
    output = File.stream!(path, [:write, :utf8])

    data
    |> Stream.map(&[&1.artist, &1.album, &1.track, &1.timestamp])
    |> CSV.encode()
    |> Stream.into(output)
    |> Stream.run()
  end

  def import(path) do
    data =
      path
      |> File.stream!([:read, :utf8])
      |> CSV.decode(headers: ["artist", "album", "track", "timestamp"])
      |> Enum.reduce([], fn
        {:ok, item}, acc -> [Entry.new(item) | acc]
        {:error, _}, acc -> acc
      end)

    {:ok, data}
  end
end
