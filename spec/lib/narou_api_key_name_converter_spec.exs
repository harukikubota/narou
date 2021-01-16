defmodule NarouApiKeyNameConverterSpec do
  use ESpec
  use Narou.Query
  alias Narou.ApiKeyNameConverter, as: C

  describe "exec" do
    context "good" do
      subject do: from(:novel, select: [:ncode, :u, :writer]) |> Map.get(:select) |> C.exec(:novel)

      it do: is_expected() |> to(eq [:n, :u, :w])
    end

    context "can not convert keys" do
      subject do: from(:novel, select: [:hoge, :fuga]) |> Map.get(:select) |> C.exec(:novel)

      it do: is_expected() |> to(eq [:hoge, :fuga])
    end
  end
end
