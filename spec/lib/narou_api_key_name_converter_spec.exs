defmodule NarouApiKeyNameConverterSpec do
  use ESpec
  use Narou.Query
  alias Narou.ApiKeyNameConverter, as: C

  describe "exec" do
    context "good" do
      let :cols, do: Narou.init() |> select([:ncode, :u, :writer]) |> Map.get(:select) |> C.exec(:novel)

      it do: expect cols() |> to(eq [:n, :u, :w])
    end

    context "can not convert keys" do
      let :cols, do: Narou.init() |> select([:hoge, :fuga]) |> Map.get(:select) |> C.exec(:novel)

      it do: expect cols() |> to(eq [:hoge, :fuga])
    end
  end
end