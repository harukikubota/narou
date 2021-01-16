defmodule Narou.Entity.Rank do
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

  use Narou.Entity, where: %{y: 2013, m: 5, d: 1, t: List.first(@rank_types)}

  validates :where, by: &__MODULE__.valid_where?/1

  def valid_where?(map) do
    {%{y: year, m: month, d: day, t: type}, other} = Map.split(map, [:y, :m, :d, :t])

    cond do
      map_size(other) > 0 -> {:error, "Unexpected keys #{inspect(Map.keys(other))}"}

      !Enum.member?(@rank_types, type) -> {:error, "must be one of #{inspect(@rank_types)}"}

      true -> case Date.new(year, month, day) do
        {:ok, _}    -> true
        {:error, _} -> {:error, "invalid date."}
      end
    end
  end
end
