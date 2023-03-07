defmodule LocalFM.CLI do
  @moduledoc """
  Main CLI app. Parse command line arguments and pass to core functions.
  """

  alias LocalFM.CLI.Config

  def main(args) do
    opts = Config.parse(args)

    IO.puts "\n  retrieving data from MoodeAudio..."
    {:ok, data} = LocalFM.retrieve_data()

    IO.puts "  parsing data..."
    {:ok, entries} = LocalFM.parse_data(data)

    IO.puts "  calculating statistics..."
    {:ok, stats} = LocalFM.generate_stats(entries, opts)

    IO.puts "  done!"

    case opts.output do
      :text -> LocalFM.Output.Text.print(stats)
      _ -> raise "Output not yet implemented..."
    end
  end
end
