defmodule Mix.Tasks.Stats do
  @moduledoc "Generate and show play history stats"
  @shortdoc "Show play stats"

  use Mix.Task

  import LocalFM.Helpers, only: [info: 1]

  @requirements ["app.config", "app.start"]

  @impl Mix.Task
  def run(args) do
    opts = LocalFM.Options.parse(args)

    IO.puts("\nProcessing statistics:\n")

    info("Calculating statistics from database...")
    {:ok, stats} = LocalFM.History.Stats.build(opts)

    info("Done!")

    case opts.output do
      :text -> LocalFM.Output.Text.print(stats)
      invalid -> raise "Output #{inspect(invalid)} not yet implemented"
    end
  end
end
