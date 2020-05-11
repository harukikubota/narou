defmodule Narou.APIStruct.User do
  @moduledoc """

  ユーザ検索API用データ。
  """

  @order_types [
    :new,            # ユーザIDの新しい順
    :novelcnt,       # 小説投稿数の多い順
    :reviewcnt,      # レビュー投稿数の多い順
    :novellength,    # 小説累計文字数の多い順
    :sumglobalpoint, # 総合評価ポイントの合計の多い順
    :old             # ユーザIDの古い順
  ]

  use Narou.APIStruct,
    limit: 20,
    st: 1,
    select: [],
    where: %{},
    order: List.first(@order_types),
    validate: [:limit, :st, :select, :order],
    validate_use_value: [order: @order_types]
end
