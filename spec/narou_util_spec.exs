defmodule NarouUtilSpec do
  use ESpec
  import Narou.Util

  describe "is_ncode" do
    context "small_format" do
      subject do: is_ncode "n1234a"
      it do: is_expected()|> to(be_truthy())
    end

    context "large_format" do
      subject do: is_ncode "N9999ZZZ"
      it do: is_expected()|> to(be_truthy())
    end
  end

  # TODO Elixirのバージョンをあげたときに修正する
  # is_regex/2
  describe "ncode_format" do
    it do: expect ncode_format() |> to(have __struct__: Regex)
  end

  describe "make_api_url" do
    subject do: make_api_url(Narou.Query.from(:novel))
    it do: is_expected() |> to(be_binary())
  end

  describe "novel_page_end_point" do
    it do: expect novel_page_end_point()            |> to(be_binary())
    it do: expect novel_page_end_point("n1234b")    |> to(be_ok_result())
    it do: expect novel_page_end_point("n1234b", 1) |> to(be_ok_result())

  end
end
