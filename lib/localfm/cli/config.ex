defmodule LocalFM.CLI.Config do
  @moduledoc """
  Parse command line arguments.
  """

  @type t :: %__MODULE__{
          date_range: LocalFM.DateRange.option(),
          export_path: String.t() | nil,
          limit: pos_integer,
          mode: :process | :export,
          output: :html | :text,
          source_path: String.t() | nil
        }

  defstruct date_range: {:last_n_days, 30},
            export_path: nil,
            limit: 10,
            mode: :process,
            output: :text,
            source_path: nil

  def parse(args) do
    {opts, _, _} = parse_args(args)

    %__MODULE__{}
    |> put_mode(export: opts[:export])
    |> put_source_path(source: opts[:source])
    |> put_date_range(opts)
    |> put_limit(opts[:limit])
    |> put_output(opts[:output])
  end

  # TODO: introduce option to keep downloaded data
  defp parse_args(args) do
    OptionParser.parse(
      args,
      aliases: [
        n: :limit,
        a: :all_time,
        o: :output,
        d: :last_days,
        s: :source,
        y: :year
      ],
      strict: [
        all_time: :boolean,
        export: :string,
        last_days: :integer,
        limit: :integer,
        output: :string,
        source: :string,
        year: :integer
      ]
    )
  end

  defp put_mode(config, export: path) when is_binary(path),
    do: %{config | mode: :export, export_path: path}

  defp put_mode(config, _), do: config

  defp put_source_path(config, source: path) when is_binary(path),
    do: %{config | source_path: path}

  defp put_source_path(config, _), do: config

  defp put_date_range(config, opts) do
    cond do
      opts[:all_time] -> %{config | date_range: {:all_time, nil}}
      opts[:last_days] -> %{config | date_range: {:last_n_days, opts[:last_days]}}
      opts[:year] -> %{config | date_range: {:by_year, opts[:year]}}
      true -> config
    end
  end

  defp put_limit(config, nil), do: config
  defp put_limit(config, n) when n > 0, do: %{config | limit: n}

  defp put_limit(_config, n) do
    raise ArgumentError, "invalid limit: #{n}; must be a positive integer"
  end

  defp put_output(config, nil), do: config
  defp put_output(config, "html"), do: %{config | output: :html}
  defp put_output(config, "text"), do: %{config | output: :text}

  defp put_output(_config, type) do
    raise ArgumentError, "unknown output type: \"#{type}\""
  end
end
