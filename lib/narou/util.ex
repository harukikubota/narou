defmodule Narou.Util do
@moduledoc """
UtilityModule.
"""

  @spec is_ncode(binary) :: true | false
  def is_ncode(ncode) do
    Regex.match?(ncode_format(), ncode)
  end

  @spec ncode_format() :: term
  def ncode_format() do
    ~r/\A[n][\d]{4}[a-z]+\z/i
  end
end