defmodule LocalFM do
  @opts %LocalFM.CLI.Config{}

  def run do
    {:ok, data} = retrieve_data()
    {:ok, entries} = parse_data(data)
    {:ok, stats} = generate_stats(entries)

    stats
  end

  def retrieve_data, do: LocalFM.Downloader.retrieve_data()
  def parse_data(data), do: LocalFM.Parser.parse(data)
  def generate_stats(entries, opts \\ @opts), do: LocalFM.Stats.generate(entries, opts)
end
