defmodule Narou.ApiKeyNameConverter do
@moduledoc """
    selectのカラム名を変換するためのモジュール。

select句に指定する値は下記表を参照。

下記表にない値の場合はそのままとなるので、注意すること。

## Novel

  |      full_key     |  api  |     description     |
  |-------------------|-------|---------------------|

  |  title            |   t    |小説名

  |  ncode            |   n    |Nコード

  |  userid           |   u    |作者のユーザID(数値)

  |  writer           |   w    |作者名

  |  story            |   s    |小説のあらすじ

  |  biggenre         |   bg   |大ジャンル

  |  genre            |   gf   |ジャンル

  |  keyword          |   kf   |キーワード

  |  general_firstup  |   gf   |初回掲載日(YYYY-MM-DD HH:MM:SS)

  |  general_lastup   |   gl   |最終掲載日(YYYY-MM-DD HH:MM:SS)

  |  novel_type       |   nt   |連載:1, 短編:2

  |  end              |   e    |短編小説&完結済小説:0, 連載中:1

  |  general_all_no   |   ga   |全掲載部分数

  |  length           |   l    |小説文字数

  |  time             |   ti   |読了時間(分単位)

  |  isstop           |   i    |長期連載停止中:1, それ以外:0

  |  isr15            |   ir   |キーワードに「R15」が含まれる場合:1, それ以外:0

  |  isbl             |   ibl  |キーワードに「ボーイズラブ」が含まれる場合:1, それ以外:0

  |  isgl             |   igl  |キーワードに「ガールズラブ」が含まれる場合:1, それ以外:0

  |  iszankoku        |   izk  |キーワードに「残酷な描写あり」が含まれる場合:1, それ以外:0

  |  istensei         |   its  |キーワードに「異世界転生」が含まれる場合:1, それ以外:0

  |  istenni          |   iti  |キーワードに「異世界転移」が含まれる場合:1, それ以外:0

  |  pc_or_k          |   p    |1:ケータイのみ, 2:PCのみ, 3:PCとケータイで投稿された作品

  |  global_point     |   gp   |総合評価ポイント

  |  daily_point      |   dp   |日間ポイント

  |  weekly_point     |   wp   |週間ポイント

  |  monthly_point    |   mp   |月間ポイント

  |  quarter_point    |   qp   |四半期ポイント

  |  yearly_point     |   yp   |年間ポイント

  |  fav_novel_cnt    |   f    |ブックマーク数

  |  impression_cnt   |   imp  |感想数

  |  review_cnt       |   r    |レビュー数

  |  all_point        |   a    |評価ポイント

  |  all_hyoka_cnt    |   ah   |評価者数

  |  sasie_cnt        |   sa   |挿絵の数

  |  kaiwaritu        |   ka   |会話率

  |  novelupdated_at  |   nu   |小説の更新日時

  |  updated_at       |   ua   |最終更新日時


## User

  |      full_key     |  api  |     description     |
  |-------------------|-------|---------------------|

  |  userid           |   u   | ユーザID

  |  name             |   n   | ユーザ名

  |  yomikata         |   y   | ユーザ名のフリガナ

  |  name1st          |   1   | ユーザ名のフリガナの頭文字, ひらがな以外の場合はnullまたは空文字

  |  novel_cnt        |   nc  | 小説投稿数

  |  review_cnt       |   rc  | レビュー投稿数

  |  novel_length     |   nl  | 小説累計文字数

  |  sum_global_point |   sg  | 総合評価ポイントの合計

"""

  @spec exec(atom, list(atom)) :: map
  def exec(select_cols, type) do
    select_cols |> Enum.map(&fetch(&1, type))
  end

  @spec fetch(atom, atom) :: atom
  def fetch(key, type) do
    val = Map.get key_map(type), key

    cond do
      is_nil(val) -> key
      true        -> val
    end
  end

  defp key_map(:novel) do
    %{
      title:           :t,
      ncode:           :n,
      userid:          :u,
      writer:          :w,
      story:           :s,
      biggenre:        :bg,
      genre:           :gf,
      keyword:         :kf,
      general_firstup: :gf,
      general_lastup:  :gl,
      novel_type:      :nt,
      end:             :e,
      general_all_no:  :ga,
      length:          :l,
      time:            :ti,
      isstop:          :i,
      isr15:           :ir,
      isbl:            :ibl,
      isgl:            :igl,
      iszankoku:       :izk,
      istensei:        :its,
      istenni:         :iti,
      pc_or_k:         :p,
      global_point:    :gp,
      daily_point:     :dp,
      weekly_point:    :wp,
      monthly_point:   :mp,
      quarter_point:   :qp,
      yearly_point:    :yp,
      fav_novel_cnt:   :f,
      impression_cnt:  :imp,
      review_cnt:      :r,
      all_point:       :a,
      all_hyoka_cnt:   :ah,
      sasie_cnt:       :sa,
      kaiwaritu:       :ka,
      novelupdated_at: :nu,
      updated_at:      :ua
    }
  end

  defp key_map(:user) do
    %{
      userid:             :u,
      name:               :n,
      yomikata:           :y,
      name1st:            "1",
      novel_cnt:          :nc,
      review_cnt:         :rc,
      novel_length:       :nl,
      sum_global_point:   :sg
    }
  end
end
