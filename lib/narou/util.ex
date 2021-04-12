defmodule Narou.Util do
  @moduledoc """
  UtilityModule.
  """

  @spec is_symbol?(term) :: boolean()
  def is_symbol?(val) do
    is_atom(val) && Regex.match?(~r/^[a-z\d]{1,}([a-z\d\_]*[a-z\d]{1,})*$/, to_string(val))
  end

  @doc """
  NCodeのフォーマットかチェックする。
  """
  @spec is_ncode(binary) :: boolean()
  def is_ncode(ncode) do
    Regex.match?(ncode_format(), ncode)
  end

  @doc """
  NcodeのRegexを返す
  """
  @spec ncode_format() :: %Regex{}
  def ncode_format() do
    ~r/\A[n][\d]{4}[a-z]+\z/i
  end

  @doc """
      入力のコンテキストでAPIサーバへのリクエストURLを作成する。

  ## EXAMPLE
      iex> Narou.init |> Narou.Util.make_url
  """
  @spec make_api_url(struct) :: {:ok, binary} | {:error, binary}
  def make_api_url(map) when is_struct(map) do
    end_point() <> Narou.QueryBuilder.build(map)
  end
  def make_url(_bad_param), do: {:error, "bad_parameter"}

  @spec end_point() :: binary
  def end_point(), do: Narou.Client.init.endpoint

  @doc """
      小説家になろうの作品ページのURLを作成する。

  ## EXAMPLE
      iex> import Narou.Util
      iex> novel_page_end_point
      "https://ncode.syosetu.com"

      iex> novel_page_end_point("n2267be")
      {:ok, "https://ncode.syosetu.com/n2267be"}

      iex> novel_page_end_point("n2267be", 1)
      {:ok, "https://ncode.syosetu.com/n2267be/1"}
  """
  def novel_page_end_point, do: "https://ncode.syosetu.com"

  @spec novel_page_end_point(binary) :: {:ok, binary} | {:error, binary}
  def novel_page_end_point(maybe_ncode) when is_binary(maybe_ncode) do
    if is_ncode(maybe_ncode) do
      {:ok, "#{novel_page_end_point()}/#{maybe_ncode}"}
    else
      {:error, "`ncode` is expected to be the first argument."}
    end
  end

  def novel_page_end_point(_maybe_ncode), do: {:error, "`ncode` is binary only."}

  @spec novel_page_end_point(binary, pos_integer) :: {:ok, binary} | {:error, binary}
  def novel_page_end_point(ncode, episode_id) when is_integer(episode_id) and episode_id > 0 do
    {:ok, "#{elem(novel_page_end_point(ncode), 1)}/#{episode_id}"}
  end

  def novel_page_end_point(_ncode, _episode_id), do: {:error, "`episode_id` is unsigned_integer only."}
end
