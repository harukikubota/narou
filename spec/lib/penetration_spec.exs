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
#
#    context "maximum_fetch_mode" do
#      before do: {
#        :shared,
#        res: Narou.init(type: :novel, maximum_fetch_mode: true) |> select([:n]) |> Narou.run!
#      }
#
#      let! :response, do: shared.res
#      let! :uniq_check, do: response() |> elem(2) |> Enum.uniq_by(&(&1.ncode))
#
#      it do: expect response()   |> to(match_pattern {:ok, _, _})
#      it do: expect uniq_check() |> to(have_count 2499)
#    end
#  end
#
#  describe "Rank" do
#    context "good" do
#      before do: {:shared, res: Narou.init(type: :rank) |> where(y: 2020, m: 3, d: 31, t: :d) |> Narou.run!}
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
#
#  describe "Rankin" do
#    context "good" do
#      before do: {:shared, res: Narou.init(type: :rankin) |> where(ncode: "n2267be") |> Narou.run!}
#      let! :records, do: shared.res |> elem(1)
#      let! :rec,     do: shared.res |> elem(1) |> hd
#
#      it do: expect shared.res |> to(match_pattern {:ok, _})
#      it do: expect records() |> length |> to(be :>, 0)
#      it do: expect rec()               |> to(have pt: 90)
#      it do: expect rec()               |> to(have rank: 103)
#      it do: expect rec()               |> to(have rtype: "20130501-d")
#    end
#  end
#
#  describe "User" do
#    context "good" do
#      before do: {:shared, res: Narou.init(type: :user) |> select([:userid, :name, :yomikata]) |> where(userid: 235132) |> Narou.run!}
#      let! :rec, do: shared.res |> elem(2) |> hd
#
#      it do: expect shared.res |> to(match_pattern {:ok, 1, _})
#      it do: expect rec() |> to(have userid:   235132)
#      it do: expect rec() |> to(have name:     "鼠色猫/長月達平")
#      it do: expect rec() |> to(have yomikata: "ネズミイロネコ/ナガツキタッペイ")
#    end
#  end
end
