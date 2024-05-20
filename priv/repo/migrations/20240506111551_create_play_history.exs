defmodule LocalFM.Repo.Migrations.CreatePlayHistory do
  use Ecto.Migration

  def change do
    create table("play_history") do
      add(:album, :string)
      add(:artist, :string)
      add(:album_artist, :string)
      add(:timestamp, :naive_datetime)
      add(:track, :string)
    end

    create(unique_index("play_history", [:artist, :album, :album_artist, :track, :timestamp]))
    create(index("play_history", [:artist, :album, :track]))
    create(index("play_history", [:album, :album_artist]))
    create(index("play_history", [:album_artist]))
  end
end
