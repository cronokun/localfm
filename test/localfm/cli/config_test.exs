defmodule LocalFM.CLI.ConfigTest do
  use ExUnit.Case, async: true

  alias LocalFM.CLI.Config

  test "default options" do
    assert Config.parse([]) == %Config{
      date_range: :last_30_days,
      limit: 10,
      output: :text
    }
  end

  test "limit option" do
    assert %Config{limit: 999} = Config.parse(["--limit", "999"])
    assert %Config{limit: 10} = Config.parse(["--limit", "PWND"])

    assert_raise ArgumentError, "invalid limit: -1; must be a positive integer", fn ->
      Config.parse(["--limit", "-1"])
    end
  end

  test "date range options" do
    assert %Config{date_range: :last_7_days} = Config.parse(["--last-days", "7"])
    assert %Config{date_range: :last_30_days} = Config.parse(["--last-days", "30"])
    assert %Config{date_range: :last_90_days} = Config.parse(["--last-days", "90"])
    assert %Config{date_range: :last_180_days} = Config.parse(["--last-days", "180"])
    assert %Config{date_range: :last_365_days} = Config.parse(["--last-days", "365"])
    assert %Config{date_range: :all_time} = Config.parse(["--all-time"])

    assert_raise ArgumentError, "unsupporten range \"--last-days 999\"; choose one from 7, 30, 90, 180, 365", fn ->
      Config.parse(["--last-days", "999"])
    end
  end

  test "output option" do
    assert %Config{output: :text} = Config.parse(["--output", "text"])
    assert %Config{output: :html} = Config.parse(["--output", "html"])

    assert_raise ArgumentError, "unknown output type: \"foobar\"", fn ->
      Config.parse(["--output", "foobar"])
    end
  end

  test "aliases" do
    assert %Config{
      date_range: :last_180_days,
      limit: 5,
      output: :html
    } = Config.parse(~w[-n 5 -d 180 -o html])
  end
end
