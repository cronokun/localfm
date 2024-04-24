defmodule LocalFM.CLI do
  @moduledoc """
  Main CLI app. Parse command line arguments and pass to core functions.
  """

  alias LocalFM.CLI.Config

  def main(args) do
    opts = Config.parse(args)

    case opts.mode do
      :process -> do_process(opts)
      :export -> do_export(opts.export_path)
    end
  end

  defp do_process(opts) do
    IO.puts("Processing stats")

    {:ok, entries} =
      case opts.source_path do
        path when is_binary(path) ->
          info("Reading from source file")
          LocalFM.CSV.import(path)

        _ ->
          info("Retrieving data from MoodeAudio")
          {:ok, data} = LocalFM.retrieve_data()

          info("Parsing data")
          LocalFM.parse_data(data)
      end

    info("Calculating statistics")
    {:ok, stats} = LocalFM.generate_stats(entries, opts)

    info("Done!")

    case opts.output do
      :text -> LocalFM.Output.Text.print(stats)
      _ -> raise "Output not yet implemented..."
    end
  end

  defp do_export(path) do
    IO.puts("Exporting CSV data")

    info("Retrieving data from MoodeAudio")
    {:ok, data} = LocalFM.retrieve_data()

    info("Parsing data")
    {:ok, entries} = LocalFM.parse_data(data)

    info("Exporting CSV")
    :ok = LocalFM.CSV.export(entries, path)

    info("Done!")
  end

  defp info(msg) when is_binary(msg) do
    IO.puts("\e[1;32m[ info ]\e[0m  #{msg}")
  end
end
