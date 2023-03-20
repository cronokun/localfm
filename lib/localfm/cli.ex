defmodule LocalFM.CLI do
  @moduledoc """
  Main CLI app. Parse command line arguments and pass to core functions.
  """

  alias LocalFM.CLI.Config

  def main(args) do
    opts = Config.parse(args)

    IO.puts("") # new line
    info "Retrieving data from MoodeAudio"
    {:ok, data} = LocalFM.retrieve_data()

    info "Parsing data"
    {:ok, entries} = LocalFM.parse_data(data)

    info "Calculating statistics"
    {:ok, stats} = LocalFM.generate_stats(entries, opts)

    info "Done!"

    case opts.output do
      :text -> LocalFM.Output.Text.print(stats)
      _ -> raise "Output not yet implemented..."
    end
  end

  defp info(msg) when is_binary(msg) do
    IO.puts "\e[1;32m[ info ]\e[0m  " <> msg
  end
end
