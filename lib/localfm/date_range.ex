defmodule LocalFM.DateRange do
  @moduledoc """
  This module provides different types of filtering by date range.
  """

  @type option :: {:all_time | :by_year | :last_n_days, pos_integer | nil}

  @spec choose(option()) :: (LocalFM.Entry.t() -> boolean())
  def choose({:all_time, nil}), do: fn _entry -> true end

  def choose({:by_year, year}) do
    fn entry -> entry.timestamp.year == year end
  end

  def choose({:last_n_days, days}) do
    now = Date.utc_today()
    start = Date.add(now, -days)
    range = Date.range(start, now)

    fn entry -> NaiveDateTime.to_date(entry.timestamp) in range end
  end
end
