defmodule LocalFM.Repo.Migrations.CreatePlayHistory do
  use Ecto.Migration

  def change do
    create table("play_history") do
      add(:artist, :string)
      add(:album, :string)
      add(:track, :string)
      add(:timestamp, :naive_datetime)
    end

    create(unique_index("play_history", [:artist, :album, :track, :timestamp]))
  end
end
