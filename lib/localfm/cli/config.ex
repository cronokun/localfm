defmodule LocalFM.CLI.Config do
  @moduledoc """
  Parse command line arguments.
  """

  @type t :: %__MODULE__{
          limit: pos_integer,
          date_range: LocalFM.DateRange.option(),
          output: :html | :text
        }

  defstruct limit: 10, date_range: :last_30_days, output: :text

  def parse(args) do
    {opts, _, _} = parse_args(args)

    %__MODULE__{}
    |> put_date_range(opts[:all_time] || opts[:last_days])
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
        d: :last_days
      ],
      strict: [
        limit: :integer,
        last_days: :integer,
        all_time: :boolean,
        output: :string
      ]
    )
  end

  defp put_date_range(config, nil), do: config
  defp put_date_range(config, true), do: Map.put(config, :date_range, :all_time)
  defp put_date_range(config, 7), do: Map.put(config, :date_range, :last_7_days)
  defp put_date_range(config, 30), do: Map.put(config, :date_range, :last_30_days)
  defp put_date_range(config, 90), do: Map.put(config, :date_range, :last_90_days)
  defp put_date_range(config, 180), do: Map.put(config, :date_range, :last_180_days)
  defp put_date_range(config, 365), do: Map.put(config, :date_range, :last_365_days)

  defp put_date_range(_config, n) do
    raise ArgumentError,
          "unsupporten range \"--last-days #{n}\"; choose one from 7, 30, 90, 180, 365"
  end

  defp put_limit(config, nil), do: config
  defp put_limit(config, n) when n > 0, do: Map.put(config, :limit, n)

  defp put_limit(_config, n) do
    raise ArgumentError, "invalid limit: #{n}; must be a positive integer"
  end

  defp put_output(config, nil), do: config
  defp put_output(config, "html"), do: Map.put(config, :output, :html)
  defp put_output(config, "text"), do: Map.put(config, :output, :text)

  defp put_output(_config, type) do
    raise ArgumentError, "unknown output type: \"#{type}\""
  end
end
