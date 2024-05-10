import Config

config :localfm, LocalFM.Downloader,
  host: "moode.local",
  source_path: "/var/log/moode_playhistory.log"
