defmodule LocalFM do
  @opts %LocalFM.Options{}

  def run do
    {:ok, data} = fetch_data!()
    {:ok, entries} = parse_data(data)
    {:ok, stats} = generate_stats(entries)

    stats
  end

  def fetch_data!, do: LocalFM.Downloader.fetch_data!()
  def parse_data(data), do: LocalFM.Parser.parse(data)
  def generate_stats(entries, opts \\ @opts), do: LocalFM.Stats.generate(entries, opts)
end
