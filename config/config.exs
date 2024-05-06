import Config

config :localfm, ecto_repos: [LocalFM.Repo]

config :localfm, LocalFM.Repo, database: Path.expand("./priv/localfm.db")

config :localfm, LocalFM.Downloader,
  host: "moode.local",
  source_path: "/var/log/moode_playhistory.log"
