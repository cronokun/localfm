defmodule LocalFM.Repo do
  use Ecto.Repo,
    otp_app: :localfm,
    adapter: Ecto.Adapters.SQLite3
end
