defmodule LocalFM.History do
  @moduledoc """
  TBD
  """

  alias LocalFM.Entry
  alias LocalFM.History.Track
  alias LocalFM.Repo

  def import(entries) do
    n =
      entries
      |> Stream.map(&Map.from_struct/1)
      |> Stream.chunk_every(1_000)
      |> Enum.reduce(0, fn batch, acc ->
        {n, _} = Repo.insert_all(Track, batch, on_conflict: :nothing)
        acc + n
      end)

    {:ok, n}
  end

  def insert(entry) when is_struct(entry, Entry) do
    %Track{} |> Track.changeset(Map.from_struct(entry)) |> Repo.insert()
  end
end
