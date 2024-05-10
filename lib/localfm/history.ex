defmodule LocalFM.History do
  @moduledoc """
  TBD
  """

  alias LocalFM.Entry
  alias LocalFM.History.Track
  alias LocalFM.Repo

  def import(entries) do
    data = Enum.map(entries, &Map.from_struct/1)
    Repo.insert_all(Track, data, on_conflict: :nothing)
  end

  def insert(entry) when is_struct(entry, Entry) do
    %Track{} |> Track.changeset(Map.from_struct(entry)) |> Repo.insert()
  end
end
