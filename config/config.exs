import Config

config :localfm, LocalFM.Downloader,
  curl_bin_path: "/opt/homebrew/opt/curl/bin/curl",
  source_url: "sftp://moode.local/var/log/moode_playhistory.log"
