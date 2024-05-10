defmodule LocalFM.History.Track do
  @moduledoc """
  TBD
  """

  use Ecto.Schema

  alias Ecto.Changeset

  # TODO: add `album_artist`?
  schema "play_history" do
    field(:artist, :string)
    field(:album, :string)
    field(:track, :string)
    field(:timestamp, :naive_datetime)
  end

  def changeset(track, params) do
    track
    |> Changeset.cast(params, [:artist, :album, :track, :timestamp])
    |> Changeset.validate_required([:artist, :album, :track, :timestamp])
  end
end
