defmodule Mix.Tasks.Stats do
  @moduledoc "Generate and show play history stats"
  @shortdoc "Show play stats"

  use Mix.Task

  @requirements ["app.config", "app.start"]

  @impl Mix.Task
  def run(args) do
    opts = LocalFM.Options.parse(args)

    IO.puts("\nProcessing statistics:\n")

    {:ok, entries} =
      case opts.source_path do
        path when is_binary(path) ->
          info("Reading data from source file...")
          LocalFM.CSV.import(path)

        _ ->
          info("Retrieving data from MoodeAudio...")
          {:ok, data} = LocalFM.retrieve_data()

          info("Parsing data...")
          LocalFM.parse_data(data)
      end

    info("Calculating statistics...")
    {:ok, stats} = LocalFM.generate_stats(entries, opts)

    info("Done!")

    case opts.output do
      :text -> LocalFM.Output.Text.print(stats)
      invalid -> raise "Output #{inspect(invalid)} not yet implemented"
    end
  end

  defp info(msg) when is_binary(msg) do
    IO.puts("\e[1;32m[ info ]\e[0m  #{msg}")
  end
end
