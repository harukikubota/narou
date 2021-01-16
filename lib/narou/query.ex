defmodule Narou.Query do
@moduledoc """
クエリ実行モジュール。
"""

  @query_names [:select, :where, :order]

@doc """
only import Narou.Query
"""
  defmacro __using__(_opts) do
    quote do
      import Narou.Query
    end
  end

    @doc """
      Entityの生成、クエリ実行を行う。

  ## @param
    - type_sym_or_querable symbol || %EntitySubModules{} ： APIタイプ、またはEntityStructを指定する。
    - opt  Keyword ： Narou.init/1に渡すオプション、クエリパラメータを指定する。

  ### EXAMPLE
      use Narou.Query

      # `Narou.init type: :novel, limit: 1, st: 1`と等価なコード
      from(:novel, limit: 1, st: 1)

      # `Narou.init |> select([:ncode, :userid])`と等価なコード
      from(:novel, select: [:ncode, :userid])

      # クエリの結合
      base_query = from :novel, limit: 1

      # fromを使用する場合
      from base_query, select: :n

      # fromを使用しない場合
      select(base_query, :n)

  ## User

  ### @param
    - colmuns list(symbol) ： 上記API仕様書の'要素'カラムのキー、または'ofパラメータ'を指定する。

    iexで確認する場合は以下を実行する。

    iex> h Narou.ApiKeyNameConverter

  ### EXAMPLE
      use Narou.Query

      Narou.init(type: :user) |> select(:name)

      Narou.init(type: :user) |> select([:name, :userid])

  """
  def from(type_sym_or_querable, opt \\ []) do
    {query_opt, init_opt} = Keyword.split(opt, @query_names)

    querable = Narou.Entity.init_or_update(type_sym_or_querable, init_opt)

    Enum.reduce(query_opt, querable, fn {query, arg}, querable -> apply(__MODULE__, query, [querable, arg]) end)
  end

  @spec select(map, list) :: map | {:error, binary}
  @doc """
      取得するカラムを選択する。

  ## 対応するAPI
    - Novel https://dev.syosetu.com/man/api/#link6
    - User  https://dev.syosetu.com/man/userapi/#link6

  ## Novel

  ### @param
    - colmuns list(symbol) ： 上記API仕様書の'要素'カラムのキー、または'ofパラメータ'を指定する。

    iexで確認する場合は以下を実行する。

    iex> h Narou.ApiKeyNameConverter

  ### EXAMPLE
      use Narou.Query

      Narou.init |> select(:ncode)

      Narou.init |> select([:ncode, :userid])

  ## User

  ### @param
    - colmuns list(symbol) ： 上記API仕様書の'要素'カラムのキー、または'ofパラメータ'を指定する。

    iexで確認する場合は以下を実行する。

    iex> h Narou.ApiKeyNameConverter

  ### EXAMPLE
      use Narou.Query

      Narou.init(type: :user) |> select(:name)

      Narou.init(type: :user) |> select([:name, :userid])

  """
  def select(map, columns), do: query_exec(map, :select, List.wrap(columns), &select_by/2)
  defp select_by(:novel, new_col), do: {:ok, &(&1 ++ new_col)}
  defp select_by(:user, new_col),  do: {:ok, &(&1 ++ new_col)}
  defp select_by(type, _),         do: {:error, not_support(type, :select)}

  @doc """
      取得するカラムの条件を指定する。

  ## 対応するAPI
    - Novel  https://dev.syosetu.com/man/api/#link4
    - Rank   https://dev.syosetu.com/man/rankapi/#link3   (rtypeのみ)
    - Rankin https://dev.syosetu.com/man/rankinapi/#link3 (ncodeのみ)
    - User   https://dev.syosetu.com/man/userapi/#link4

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
    - t symbol  ： ランキングタイプを指定する。 指定可能な値は Narou.Entity.Rank.@rank_types を参照。

  ### EXAMPLE
      use Narou.Query

      # 2020/12/31 のデイリーランキング
      Narou.init(type: :rank) |> where(y: 2020, m: 12, d: 31, t: d)

  ## Rankin
  ### @param
    - ncode binary ： ncodeを指定する。

  ### EXAMPLE
      use Narou.Query

      Narou.init(type: :rankin) |> where(ncode: "n2267be")

  ## User
  ### @param
    - kl list(key: val) ： 上記API仕様書の'パラメータ'カラムのキーと値を指定する。

  ### EXAMPLE
      use Narou.Query

      Narou.init(type: :user) |> where(userid: 235132)

  """
  @spec where(map, list) :: map | {:error, binary}
  def where(map, kl),   do: query_exec(map, :where, kl, &where_by/2)
  defp where_by(_, kl), do: {:ok, &Map.merge(&1, Map.new(kl))}
  # !全てのAPIタイプで共通の処理のため、エラーハンドリングはコメントアウトしている。
  # !whereを使用しないAPIタイプがある場合はコメントアウトをはずす。
  #defp where_by(type, _),     do: {:error, not_support(type, :where)}

  @doc """
      取得したカラムのソート条件を指定する。

  ## 対応するAPI
    - Novel  https://dev.syosetu.com/man/api/#link3
    - User   https://dev.syosetu.com/man/userapi/#link3

  ## Novel
  ### @param
    - key symbol ： 上記API仕様書の'order'カラムの値を指定する。

  ### EXAMPLE
      use Narou.Query

      Narou.init |> order(:hyoka)

  ## User
  ### @param
    - key symbol ： 上記API仕様書の'order'カラムの値を指定する。

  ### EXAMPLE
      use Narou.Query

      Narou.init(type: :user) |> order(:old)

  """
  @spec order(map, atom) :: map | {:error, binary}
  def order(map, key),        do: query_exec(map, :order, key, &order_by/2)
  defp order_by(:novel, key), do: {:ok, fn _ -> key end }
  defp order_by(:user, key),  do: {:ok, fn _ -> key end }
  defp order_by(type, _),     do: {:error, not_support(type, :order) }

  defp query_exec(map, fun_key, val, fun) do
    case fun.(Map.get(map, :type), val) do
      {:error, m} -> {:error, m}
      {:ok, fun}  -> Map.update!(map, fun_key, &(fun.(&1))) |> validate()
    end
  end

  defp not_support(type, query), do: "The API type :#{type} does not support `#{query}` queries."
  defp validate(s), do: Narou.Entity.validate(s)
end
