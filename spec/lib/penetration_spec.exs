defmodule PenetrationSpec do
@moduledoc """
!!! 実際にAPIを叩くので、普段はコメントアウトする。 !!!
"""

  use ESpec
  use Narou

#  describe "Novel" do
#    context "no format" do
#      before do: {:shared, res: Narou.init() |> select([:t, :w, :n]) |> where(ncode: "n2267be") |> Narou.run!}
#      let! :rec, do: shared.res |> elem(2) |> hd
#
#      it do: expect shared.res |> to(match_pattern {:ok, 1, _})
#      it do: expect rec() |> to(have ncode:  "N2267BE")
#      it do: expect rec() |> to(have title:  "Ｒｅ：ゼロから始める異世界生活")
#      it do: expect rec() |> to(have writer: "鼠色猫/長月達平")
#    end
#
#    context "with format" do
#      before do: {:shared, res: Narou.init() |> select([:n]) |> where(ncode: ["n6169dz", "n6458eg"]) |> Narou.run! |> Narou.format}
#      let! :rec, do: shared.res |> elem(2)
#
#      it do: expect shared.res |> to(match_pattern {:ok, 2, _})
#      it do: expect rec() |> hd       |> to(have ncode: "n6169dz")
#      it do: expect rec() |> tl |> hd |> to(have ncode: "n6458eg")
#    end
#  end
#
#  describe "Rank" do
#    context "good" do
#      before do: {:shared, res: Narou.init(%{type: :rank}) |> where(y: 2020, m: 3, d: 31, t: :d) |> Narou.run!}
#      let! :records, do: shared.res |> elem(1)
#      let! :rec,     do: shared.res |> elem(1) |> hd
#
#      it do: expect shared.res |> to(match_pattern {:ok, _})
#      it do: expect records()  |> to(have_length 300)
#      it do: expect rec()      |> to(have ncode: "N7378GC")
#      it do: expect rec()      |> to(have pt: 4450)
#      it do: expect rec()      |> to(have rank: 1)
#    end
#  end
end