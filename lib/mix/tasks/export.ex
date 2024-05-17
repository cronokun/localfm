defmodule Mix.Tasks.Export do
  @moduledoc "Export play history from Moode in CSV format"
  @shortdoc "Export play history"

  use Mix.Task

  import LocalFM.Helpers, only: [info: 1]

  @requirements ["app.config", "app.start"]

  @impl Mix.Task
  def run([path | _args]) when is_binary(path) do
    IO.puts("\nExporting CSV data:\n")

    info("Retrieving data from MoodeAudio...")
    {:ok, data} = LocalFM.fetch_data!()

    info("Parsing data...")
    {:ok, entries} = LocalFM.parse_data(data)

    info("Exporting CSV...")
    :ok = LocalFM.CSV.export(entries, path)

    info("Done!")
  end
end
