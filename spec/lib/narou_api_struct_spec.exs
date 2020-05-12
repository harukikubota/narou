defmodule NarouAPIStructSpec do
  use ESpec
  #alias Narou.APIStruct, as: S

  describe "init" do
    context "good" do
      let :novel , do: Narou.APIStruct.init(:novel)
      let :rank  , do: Narou.APIStruct.init(:rank)
      let :rankin, do: Narou.APIStruct.init(:rankin)
      let :user  , do: Narou.APIStruct.init(:user)

      it do: expect novel()  |> to(be_ok_result())
      it do: expect novel()  |> elem(1) |> to(have __struct__: Narou.APIStruct.Novel)
      it do: expect rank()   |> elem(1) |> to(have __struct__: Narou.APIStruct.Rank)
      it do: expect rankin() |> elem(1) |> to(have __struct__: Narou.APIStruct.Rankin)
      it do: expect user()   |> elem(1) |> to(have __struct__: Narou.APIStruct.User)
    end

    context "bad" do
      let :bad_type, do: Narou.APIStruct.init(:hoge)

      it do: expect bad_type() |> to(be_error_result())
      it do: expect bad_type() |> elem(1) |> to(eq "Unexpected type `hoge`.")
    end
  end
end