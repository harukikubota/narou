defmodule NarouApiKeyNameConverterSpec do
  use ESpec
  use Narou.Query
  alias Narou.ApiKeyNameConverter, as: C

  describe "exec" do
    context "good" do
      let :cols, do: Narou.init() |> select([:ncode, :u, :writer]) |> C.exec()

      it do: expect cols() |> to(have select: [:n, :u, :w])
    end

    context "can not convert keys" do
      let :cols, do: Narou.init() |> select([:hoge, :fuga]) |> C.exec()

      it do: expect cols() |> to(have select: [:hoge, :fuga])
    end

    context "don't have a `select` column" do
      let :cols, do: Narou.init(%{type: :rank}) |> C.exec()

      it do: expect cols() |> to(eq cols())
    end
  end
end