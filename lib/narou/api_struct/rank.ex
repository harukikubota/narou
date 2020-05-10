defmodule Narou.APIStruct.Rank do
  @moduledoc """

  小説ランキングAPI用データ。
  """

  # ランキングタイプ
  @rank_types [
    :d,  # 日
    :w,  # 週
    :m,  # 月
    :q   # 四半期
  ]

  use Narou.APIStruct, where: %{y: 2013, m: 5, d: 1, t: List.first(@rank_types)}

  validates :where, by: &__MODULE__.valid_where?/1

  def valid_where?(map) do
    {%{y: year, m: month, d: day, t: type}, other} = Map.split(map, [:y, :m, :d, :t])

    cond do
      map_size(other) > 0 ->
        keys = Map.keys(other) |> Enum.map(&(":#{&1}")) |> Enum.join(", ")
        {:error, "Unexpected keys [#{keys}]"}

      !Enum.member?(@rank_types, type) ->
        types = @rank_types |> Enum.map(&(":#{&1}")) |> Enum.join(", ")
        {:error, "must be one of [#{types}]"}

      true -> case Date.new(year, month, day) do
        {:ok, _}    -> true
        {:error, _} -> {:error, "invalid date."}
      end
    end
  end
end
