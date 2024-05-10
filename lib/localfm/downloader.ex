defmodule LocalFM.Downloader do
  @moduledoc """
  Module responsible for downloading data from external source.
  """

  def retrieve_data do
    opts = Application.fetch_env!(:localfm, __MODULE__)
    [user, pass] = String.split(opts[:creds], ":")

    SFTPClient.connect!([host: opts[:host], user: user, password: pass], fn conn ->
      SFTPClient.read_file(conn, opts[:source_path])
    end)
  end
end
