defmodule Mix.Tasks.Db.Import do
  @moduledoc "Import CSV data to database"
  @shortdoc "Import data to database"

  use Mix.Task

  import LocalFM.Helpers, only: [info: 1]

  @requirements ["app.config", "app.start"]

  @impl Mix.Task
  def run([path | _args]) when is_binary(path) do
    IO.puts("\nImporting data to database")

    info("Reading data from file...")
    {:ok, entries} = LocalFM.CSV.import(path)

    info("Importing to database...")
    {n, _} = LocalFM.History.import(entries)

    info("#{n} new entries imported")
    info("Done!")
  end
end
