defmodule LocalFMTest do
  use ExUnit.Case
  doctest LocalFM

  test "greets the world" do
    assert LocalFM.hello() == :world
  end
end
