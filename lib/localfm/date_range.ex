defmodule LocalFM.DateRange do
  @type option ::
          :all_time
          | :last_7_days
          | :last_30_days
          | :last_90_days
          | :last_180_days
          | :last_365_days

  @spec choose(option) :: (LocalFM.Entry.t() -> boolean())
  def choose(:all_time), do: fn _entry -> true end
  def choose(:last_7_days), do: last_n_days_fun(7)
  def choose(:last_30_days), do: last_n_days_fun(30)
  def choose(:last_90_days), do: last_n_days_fun(90)
  def choose(:last_180_days), do: last_n_days_fun(180)
  def choose(:last_365_days), do: last_n_days_fun(365)

  defp last_n_days_fun(n) do
    now = Date.utc_today()
    start = Date.add(now, -n)
    range = Date.range(start, now)

    fn entry -> NaiveDateTime.to_date(entry.timestamp) in range end
  end
end
