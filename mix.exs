defmodule LocalFM.MixProject do
  use Mix.Project

  def project do
    [
      app: :localfm,
      version: "0.2.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LocalFM.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:csv, "~> 3.2"},
      {:ecto_sql, "~> 3.11"},
      {:ecto_sqlite3, "~> 0.15"},
      {:sftp_client, "~> 2.0"}
    ]
  end
end
