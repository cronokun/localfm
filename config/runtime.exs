import Config

config :localfm, LocalFM.Downloader, creds: System.get_env("MOODE_CREDS") || "user:password"
