defmodule Narou do
  @moduledoc """
  # 小説家になろうAPIクライアント

  ## 対応API
  - Novel  小説検索
  - Rank   ランキング検索
  - Rankin 殿堂入り検索
  - User   ユーザ検索
  """

  alias Narou.Client
  alias Narou.QueryBuilder
  alias Narou.ResultFormatter, as: Formatter
  alias Narou.APIStruct, as: S

  defmacro __using__(_opt) do
    quote do
      use Narou.Query
    end
  end

  @doc """
      リクエストを送るための初期化処理を行う。

  ## @param
    * type  - API種別を設定する。(:novel, :rank, :rankin, :user)
    * limit - 取得するデータの最大件数を設定する。(1..500, default: 20)　(Novelのみ)
    * st    - 取得するデータの開始位置を設定する。(1..2000, default: 1)　(Novelのみ)

  ## Examples
      use Narou

      Narou.init()
      |> select([:t, :w])
      |> where(ncode: "n2267be")
      |> Narou.run!

      {
        :ok,
        1,
        [
          %{
            title: => "Ｒｅ：ゼロから始める異世界生活",
            writer: => "鼠色猫/長月達平"
          }
        ]
      }

  """
  @spec init(map) :: struct | {:error, any}
  def init(opt \\ %{type: :novel}) do
    type = Map.get(opt, :type)
    s = case type do
      :novel  -> {:ok, %S.Novel{}}
      :rank   -> {:ok, %S.Rank{}}
      :rankin -> {:ok, %S.Rankin{}}
      :user   -> {:ok, %S.User{}}
      _      -> {:error, "Unexpected type `#{type}`."}
    end

    case s do
      {:error, _} -> s
      {:ok, s} ->
        s = Map.merge(s, Map.new(opt))
        case S.validate(s) do
          {:ok, v} -> v
          {:error, v} -> {:error, v}
        end
    end
  end

  @doc """
      APIサーバへリクエストする。

  ## @param
    - opt `init/1`の戻り値

  ## EXAMPLE
  `init/1`を参照。

  """
  @spec run!(map) :: {:ok, integer, list(map)} | {:no_data}
  def run!(opt) do
    opt
    |> make_uri
    |> send!
    |> decode!
    |> simple_format!(Map.get(opt, :type))
  end

  @doc """
      取得データの整形を行う。

  ## @param
    - opt `run!/1`の戻り値

  ## EXAMPLE
      use Narou

      Narou.init()
      |> select([:ncode])
      |> where(ncode: "n2267be")
      |> Narou.run!
      |> Narou.format

      {
        :ok,
        1,
        [
          %{
            # デフォルトのフォーマッタは`NCode`のみ整形する。
            ncode: "n2267be"
          }
        ]
      }

  """
  @spec format({:ok, integer, list(map)}) :: {:ok, integer, map}
  def format({:ok, count, result}), do: {:ok, count, (result |> Formatter.exec())}

  @spec format({:ok, list(map)}) :: {:ok, map}
  def format({:ok, result}), do: {:ok, (result |> Formatter.exec())}

  @doc """
    指定したフォーマッタで取得データの整形を行う。

  ## @param
    - opt `run!/1`の戻り値

  ## EXAMPLE
      # 実装詳細は`h Narou.ResultFormatter.__using__`を参照。

  """
  @spec format_with({:ok, integer, [map]}, atom) :: {:ok, integer, [map]}
  def format_with({:ok, count, result}, format_mod) do
    res = result |> Formatter.exec(format_mod)
    {:ok, count, res}
  end

  defp make_uri(map), do: QueryBuilder.build(map)
  defp send!(uri),    do: Client.init() |> Client.run(uri)
  defp decode!(%{status_code: 200, body: body}), do: Poison.decode!(body)

  defp simple_format!(result, type) do
    case Enum.member?([:novel, :user], type) do
      true  -> _simple_format(:count, result)
      false -> _simple_format(:none , result)
    end
  end

  defp _simple_format(:count, result) do
    {[%{"allcount" => count}], result} = result |> Enum.split(1)

    if count > 0 do
      {:ok, count, each_key_to_atom(result)}
    else
      {:no_data}
    end
  end
  defp _simple_format(:none, result), do: {:ok, each_key_to_atom(result)}

  defp each_key_to_atom(x), do: Enum.map(x, fn y -> y |> Map.keys |> Enum.map(&(String.to_atom(&1))) |> Enum.zip(Map.values(y)) |> Map.new end)
end
