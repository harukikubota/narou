defmodule NarouEntitySpec do
  use ESpec

  describe "init" do
    context "good" do
      let :novel , do: Narou.Entity.init(type: :novel)
      let :rank  , do: Narou.Entity.init(type: :rank)
      let :rankin, do: Narou.Entity.init(type: :rankin)
      let :user  , do: Narou.Entity.init(type: :user)

      it do: expect novel()  |> to(match_pattern %Narou.Entity.Novel{})
      it do: expect rank()   |> to(match_pattern %Narou.Entity.Rank{})
      it do: expect rankin() |> to(match_pattern %Narou.Entity.Rankin{})
      it do: expect user()   |> to(match_pattern %Narou.Entity.User{})
    end

    context "bad" do
      subject do: Narou.Entity.init(type: :hoge)
      it do: is_expected() |> to(match_pattern {:error, "Unexpected type `hoge`."})
    end
  end

  describe "to_map_for_build_query" do
    subject do: Narou.init(type: :novel) |> Narou.Entity.to_map_for_build_query

    it do: is_expected() |> to(be_map())
    it do: is_expected() |> not_to(have :__struct__)
    it do: is_expected() |> not_to(have :maximum_fetch_mode)
  end
end
