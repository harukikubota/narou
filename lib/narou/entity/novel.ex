defmodule Narou.Entity.Novel do
@moduledoc """

    小説検索API用データ。

  ## select
      iex> h Narou.ApiKeyNameConverter

  ## order
      :new,           # 新着更新順\n
      :favnovelcnt,   # ブックマーク数の多い順\n
      :reviewcnt,     # レビュー数の多い順\n
      :hyoka,         # 総合ポイントの高い順\n
      :hyokaasc,      # 総合ポイントの低い順\n
      :dailypoint,    # 日間ポイントの高い順\n
      :weeklypoint,   # 週間ポイントの高い順\n
      :monthlypoint,  # 月間ポイントの高い順\n
      :quarterpoint,  # 四半期ポイントの高い順\n
      :yearlypoint,   # 年間ポイントの高い順\n
      :impressioncnt, # 感想の多い順\n
      :hyokacnt,      # 評価者数の多い順\n
      :hyokacntasc,   # 評価者数の少ない順\n
      :weekly,        # 週間ユニークユーザの多い順\n
      :lengthdesc,    # 小説本文の文字数が多い順\n
      :lengthasc,     # 小説本文の文字数が少ない順\n
      :ncodedesc,     # 新着投稿順\n
      :old            # 更新が古い順\n
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

  use Narou.Entity,
    limit: 20,
    st: 1,
    select: [],
    where: %{},
    order: List.first(@order_types),
    validate: [:limit, :st, :select, :order],
    validate_use_value: [order: @order_types]
end
