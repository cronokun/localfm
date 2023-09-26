defmodule LocalFM.Downloader do
  @moduledoc """
  TODO: Move URL and creds to dotfiles
  """

  def retrieve_data do
    config = Application.fetch_env!(:localfm, __MODULE__)

    curl = config[:curl_bin_path]

    opts = [
      "--insecure",
      "--silent",
      "--user",
      config[:creds],
      config[:source_url]
    ]

    case System.cmd(curl, opts) do
      {data, 0} -> {:ok, data}
      {_, error_code} -> {:error, "Something went wrong (#{error_code})"}
    end
  end
end
