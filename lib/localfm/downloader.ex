defmodule LocalFM.Downloader do
  @moduledoc """
  TODO: Move URL and creds to dotfiles
  """

  @curl_bin "/opt/homebrew/opt/curl/bin/curl"
  @creds "pi:moodeaudio"
  @source_url "sftp://moode.local/var/log/moode_playhistory.log"

  def retrieve_data do
    System.cmd(@curl_bin, ["--insecure", "--silent", "--user", @creds, @source_url])
    |> case do
      {data, 0} -> {:ok, data}
      {_, error_code} -> {:error, "Something went wrong (#{error_code})"}
    end
  end
end
