defmodule Narou.APIStruct.Novel do
  @moduledoc """

  小説検索API用データ。
  """

  @order_types [
    :new,           # 新着更新順
    :favnovelcnt,   # ブックマーク数の多い順
    :reviewcnt,     # レビュー数の多い順
    :hyoka,         # 総合ポイントの高い順
    :hyokaasc,      # 総合ポイントの低い順
    :dailypoint,    # 日間ポイントの高い順
    :weeklypoint,   # 週間ポイントの高い順
    :monthlypoint,  # 月間ポイントの高い順
    :quarterpoint,  # 四半期ポイントの高い順
    :yearlypoint,   # 年間ポイントの高い順
    :impressioncnt, # 感想の多い順
    :hyokacnt,      # 評価者数の多い順
    :hyokacntasc,   # 評価者数の少ない順
    :weekly,        # 週間ユニークユーザの多い順
    :lengthdesc,    # 小説本文の文字数が多い順
    :lengthasc,     # 小説本文の文字数が少ない順
    :ncodedesc,     # 新着投稿順
    :old            # 更新が古い順
  ]

  use Narou.APIStruct, limit: 20, st: 1, select: [], where: %{}, order: List.first(@order_types), validate: [:limit, :st]

  validates :select, by: &__MODULE__.valid_select?/1
  validates :order, inclusion: @order_types

  def valid_select?(cols) do
    cols |> Enum.all?(&(is_symbol?(&1)))
  end

  defp is_symbol?(val) do
    is_atom(val) && Regex.match?(~r/^[a-z]{1,}([a-z\_]*[a-z]{1,})*$/, to_string(val))
  end
end
