defmodule NarouEntitySpec do
  use ESpec
  #alias Narou.Entity, as: S

  describe "init" do
    context "good" do
      let :novel , do: Narou.Entity.init(type: :novel)
      let :rank  , do: Narou.Entity.init(type: :rank)
      let :rankin, do: Narou.Entity.init(type: :rankin)
      let :user  , do: Narou.Entity.init(type: :user)

      it do: expect novel()  |> to(be_ok_result())
      it do: expect novel()  |> elem(1) |> to(have __struct__: Narou.Entity.Novel)
      it do: expect rank()   |> elem(1) |> to(have __struct__: Narou.Entity.Rank)
      it do: expect rankin() |> elem(1) |> to(have __struct__: Narou.Entity.Rankin)
      it do: expect user()   |> elem(1) |> to(have __struct__: Narou.Entity.User)
    end

    context "bad" do
      let :bad_type, do: Narou.Entity.init(type: :hoge)

      it do: expect bad_type() |> to(be_error_result())
      it do: expect bad_type() |> elem(1) |> to(eq "Unexpected type `hoge`.")
    end
  end

  describe "to_map_for_build_query" do
    let :entity, do: Narou.init(type: :novel) |> Narou.Entity.to_map_for_build_query

    # Enumerableかどうかのチェック
    it do: expect entity() |> Enum.each(&(&1)) |> to(eq :ok)

    it do: expect entity() |> Map.has_key?(:__struct__)         |> to(be_false())
    it do: expect entity() |> Map.has_key?(:maximum_fetch_mode) |> to(be_false())
  end
end
