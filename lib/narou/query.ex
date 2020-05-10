defmodule Narou.Query do
@moduledoc """
クエリ実行モジュール。
"""


@doc """
only import Narou.Query
"""
  defmacro __using__(_opts) do
    quote do
      import Narou.Query
    end
  end

  @spec select(map, list) :: map | {:error, binary}
  @doc """
      取得するカラムを選択する。

  ## 対応するAPI
    - Novel https://dev.syosetu.com/man/api/#link6

  ## Novel

  ### @param
    - colmuns list(symbol) ： 上記API仕様書の'要素'カラムのキー、または'ofパラメータ'を指定する。

    iexで確認する場合は以下を実行する。

    iex> h Narou.ApiKeyNameConverter

  ### EXAMPLE
      use Narou.Query

      Narou.init |> select(:ncode)

      Narou.init |> select([:ncode, :userid])
  """
  def select(map, columns), do: query_exec(map, :select, List.wrap(columns), &select_by/2)
  defp select_by(:novel, new_col), do: {:ok, &(&1 ++ new_col)}
  defp select_by(type, _),         do: {:error, not_support(type, :select)}

  @doc """
      取得するカラムの条件を指定する。

  ## 対応するAPI
    - Novel https://dev.syosetu.com/man/api/#link4
    - Rank  https://dev.syosetu.com/man/rankapi/#link3

  ## Novel
  ### @param
    - kl list(key: val) ： 上記API仕様書の'パラメータ'カラムのキーと値を指定する。

  ### EXAMPLE
      use Narou.Query

      Narou.init |> where(ncode: "n2267be")

      Narou.init |> where([ncode: "n2267be", userid: 1])

  ## Rank
  ### @param
    - y integer ： 年を指定する。
    - m integer ： 月を指定する。
    - d integer ： 日を指定する。
    - t symbol  ： ランキングタイプを指定する。 指定可能な値は Narou.APIStruct.Rank.@rank_types を参照。

  ### EXAMPLE
      use Narou.Query

      # 2020/12/31 のデイリーランキング
      Narou.init(%{type: rank}) |> where(y: 2020, m: 12, d: 31, t: d)

  """
  @spec where(map, list) :: map | {:error, binary}
  def where(map, kl), do: query_exec(map, :where, kl, &where_by/2)
  defp where_by(:novel,  kl), do: {:ok, &(Map.merge(&1, Map.new(kl)))}
  defp where_by(:rank,   kl), do: {:ok, &(Map.merge(&1, Map.new(kl)))}
  defp where_by(:rankin, kl), do: {:ok, &(Map.merge(&1, Map.new(kl)))}
  defp where_by(type, _),     do: {:error, not_support(type, :where)}

  @doc """
      取得したカラムのソート条件を指定する。

  ## 対応するAPI
    - Novel https://dev.syosetu.com/man/api/#link3

  ## Novel
  ### @param
    - key symbol ： 上記API仕様書の'order'カラムの値を指定する。

  ### EXAMPLE
      use Narou.Query

      Narou.init |> order(:hyoka)
  """
  @spec order(map, atom) :: map | {:error, binary}
  def order(map, key),        do: query_exec(map, :order, key, &order_by/2)
  defp order_by(:novel, key), do: {:ok, fn _ -> key end }
  defp order_by(type, _),     do: {:error, not_support(type, :order) }

  defp query_exec(map, fun_key, val, fun) do
    case fun.(Map.get(map, :type), val) do
      {:error, m} -> {:error, m}
      {:ok, fun}  ->
        case Map.update!(map, fun_key, &(fun.(&1))) |> validate() do
          {:ok, s}    -> s
          {:error, m} -> {:error, m}
        end
    end
  end

  defp not_support(type, query), do: "The API type :#{type} does not support `#{query}` queries."
  defp validate(s), do: Narou.APIStruct.validate(s)
end
