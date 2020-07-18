defmodule Narou.Util do
@moduledoc """
UtilityModule.

## EXAMPLE

    iex> alias Narou.Util
    iex> Util.is_ncode("n0000a")
    true
"""

  @doc """
  NCodeのフォーマットかチェックする。
  """
  @spec is_ncode(binary) :: true | false
  def is_ncode(ncode) do
    Regex.match?(ncode_format(), ncode)
  end

  @doc """
  NcodeのRegexを返す
  """
  @spec ncode_format() :: term
  def ncode_format() do
    ~r/\A[n][\d]{4}[a-z]+\z/i
  end

  @doc """
      入力のコンテキストでAPIサーバへのリクエストURLを作成する。

  ## EXAMPLE
      iex> Narou.init |> Narou.Util.make_url
  """
  @spec make_url(struct) :: {:ok, binary} | {:error, binary}
  def make_url(map) when is_struct(map) do
    end_point() <> (map |> Narou.QueryBuilder.build())
  end
  def make_url(_bad_param), do: {:error, "bad_parameter"}

  @spec end_point() :: binary
  def end_point(), do: Narou.Client.init.endpoint

  def is_symbol(val), do: is_atom(val) && Regex.match?(~r/^:.*$/, inspect(val))
end
