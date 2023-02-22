defmodule LocalFM.CLI do
  def main(_args) do
    IO.puts "\n  retrieving data from MoodeAudio..."
    {:ok, data} = LocalFM.retrieve_data()

    IO.puts "  parsing data..."
    {:ok, entries} = LocalFM.parse_data(data)

    IO.puts "  calculating statistics..."
    {:ok, stats} = LocalFM.generate_stats(entries)

    IO.puts "  done!"
    LocalFM.Output.Text.print(stats)
  end
end
