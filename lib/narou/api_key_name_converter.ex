defmodule Narou.ApiKeyNameConverter do
@moduledoc """
    selectのカラム名を変換するためのモジュール。

select句に指定する値は下記表を参照。

下記表にない値の場合はそのままとなるので、注意すること。


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

  |  isrxv            |   ir   |キーワードに「R15」が含まれる場合:1, それ以外:0 !本来のキー名は`isr15`!

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

"""

  @spec exec(map) :: map
  def exec(map) do
    case Map.has_key?(map, :select) do
      false -> map
      true  ->
        new_select_cols = Map.get(map, :select) |> Enum.map(&(fetch(&1)))
        Map.update!(map, :select, fn _ -> new_select_cols end)
    end
  end

  @spec fetch(atom) :: atom
  def fetch(key) do
    val = Map.get key_map(), key

    cond do
      is_nil(val)  -> key
      is_atom(val) -> val
    end
  end

  defp key_map do
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
      isrxv:           :ir,
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
end
