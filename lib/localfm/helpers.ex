defmodule LocalFM.Helpers do
  @moduledoc "This module contains various helpers shared accross codebase"

  def info(message) when is_binary(message) do
    IO.puts("\e[1;32m[ info ]\e[0m  #{message}")
  end
end
