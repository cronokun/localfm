defmodule LocalFM.Downloader do
  @moduledoc """
  Module responsible for downloading data from external source.
  """

  @doc "Read play history from Moode"
  def fetch_data! do
    connect!(&SFTPClient.read_file/2)
  end

  @doc "Read play history from Moode and return only lines starting from given date"
  def fetch_recent!(date) do
    data =
      connect!(fn conn, source ->
        SFTPClient.stream_file!(conn, source)
        |> stream_line_by_line()
        |> filter_by_date(date)
        |> Enum.to_list()
      end)

    {:ok, data}
  end

  defp connect!(fun) do
    opts = Application.fetch_env!(:localfm, __MODULE__)
    [user, pass] = String.split(opts[:creds], ":")
    conn_opts = [host: opts[:host], user: user, password: pass]
    SFTPClient.connect!(conn_opts, fn conn -> fun.(conn, opts[:source_path]) end)
  end

  defp stream_line_by_line(stream) do
    start_fun = fn -> "" end
    # the accumulator always contains the last line, so emit that too
    last_fun = fn acc -> {[acc], ""} end
    after_fun = fn acc -> acc end

    reducer =
      fn chunk, acc ->
        {elements, [acc]} = Enum.split(String.split(acc <> chunk, "\n"), -1)
        {elements, acc}
      end

    Stream.transform(stream, start_fun, reducer, last_fun, after_fun)
  end

  @timestamp ~r/<div>(\d{4}-\d{2}-\d{2}) /

  defp filter_by_date(stream, target_date) do
    Stream.reject(stream, fn line ->
      case Regex.run(@timestamp, line, capture: :all_but_first) do
        [date] ->
          date
          |> Date.from_iso8601!()
          |> Date.before?(target_date)

        _ ->
          true
      end
    end)
  end
end
