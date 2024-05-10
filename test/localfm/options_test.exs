defmodule LocalFM.OptionsTest do
  use ExUnit.Case, async: true

  alias LocalFM.Options

  test "default options" do
    assert Options.parse([]) == %Options{
             date_range: {:last_n_days, 30},
             limit: 10,
             output: :text
           }
  end

  test "limit option" do
    assert %Options{limit: 999} = Options.parse(["--limit", "999"])
    assert %Options{limit: 10} = Options.parse(["--limit", "PWND"])

    assert_raise ArgumentError, "invalid limit: -1; must be a positive integer", fn ->
      Options.parse(["--limit", "-1"])
    end
  end

  test "date range options" do
    assert %Options{date_range: {:all_time, nil}} = Options.parse(["--all-time"])
    assert %Options{date_range: {:last_n_days, 7}} = Options.parse(["--last-days", "7"])
    assert %Options{date_range: {:last_n_days, 365}} = Options.parse(["--last-days", "365"])
    assert %Options{date_range: {:by_year, 2010}} = Options.parse(["--year", "2010"])
  end

  test "output option" do
    assert %Options{output: :text} = Options.parse(["--output", "text"])
    assert %Options{output: :html} = Options.parse(["--output", "html"])

    assert_raise ArgumentError, "unknown output type: \"foobar\"", fn ->
      Options.parse(["--output", "foobar"])
    end
  end

  test "source option" do
    assert %Options{source_path: "/foo/bar/data.csv"} =
             Options.parse(["--source", "/foo/bar/data.csv"])
  end

  test "aliases" do
    assert %Options{
             date_range: {:last_n_days, 180},
             limit: 5,
             output: :html,
             source_path: "data.csv"
           } = Options.parse(~w[-s data.csv -n 5 -d 180 -o html])
  end
end
