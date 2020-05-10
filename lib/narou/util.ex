defmodule Narou.Util do
  def is_ncode(ncode) do
    Regex.match?(ncode_format(), ncode)
  end

  def ncode_format() do
    ~r/\A[n][\d]{4}[a-z]+\z/i
  end
end