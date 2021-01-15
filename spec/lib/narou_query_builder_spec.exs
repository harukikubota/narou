defmodule NarouQueryBuilderSpec do
  use ESpec
  alias Narou.QueryBuilder, as: Q
  import Narou.Query

  before do: {
    :shared,
    expand: (fn x ->
      %{false: [uri], true: params} = x
      |> String.split(~r/[&\?]/)
      |> Enum.group_by(&String.match?(&1, ~r/=/))
      params |> Enum.map(&String.split(&1, "="))
      |> Enum.map(fn [k,v] -> {String.to_atom(k),v} end)
      |> Map.new
      |> Map.merge(%{uri: uri})
    end)
  }

  describe "Novel" do
    context "default value" do
      subject do: from(:novel) |> Q.build |> shared.expand.()

      it do: is_expected() |> to(have uri:   "/novelapi/api")
      it do: is_expected() |> to(have lim:   "20")
      it do: is_expected() |> to(have order: "new")
      it do: is_expected() |> to(have st:    "1")
      it do: is_expected() |> to(have out:   "json")
    end

    context "exec query" do
      subject do
        from(:novel, limit: 500, st: 2000, select: [:title, :writer], where: [ncode: "n1", userid: 1], order: :old)
        |> Q.build
        |> shared.expand.()
      end

      it do: is_expected() |> to(have uri:    "/novelapi/api")
      it do: is_expected() |> to(have lim:    "500")
      it do: is_expected() |> to(have st:     "2000")
      it do: is_expected() |> to(have order:  "old")
      it do: is_expected() |> to(have of:     "t-w")
      it do: is_expected() |> to(have ncode:  "n1")
      it do: is_expected() |> to(have userid: "1")
    end
  end

  describe "Rank" do
    context "default value" do
      subject do: from(:rank) |> Q.build |> shared.expand.()

      it do: is_expected() |> to(have uri:   "/rank/rankget")
      it do: is_expected() |> to(have rtype: "20130501-d")
    end

    context "exec query" do
      subject do: from(:rank, where: [y: 2020, m: 12, d: 31, t: :m]) |> Q.build |> shared.expand.()

      it do: is_expected() |> to(have rtype: "20201231-m")
    end
  end

  describe "Rankin" do
    context "default value" do
      subject do: from(:rankin) |> Q.build |> shared.expand.()

      it do: is_expected() |> to(have uri:   "/rank/rankin")
      it do: is_expected() |> to(have ncode: "N0000A")
    end

    context "exec query" do
      subject do: from(:rankin, where: [ncode: "n9876z"]) |> Q.build |> shared.expand.()

      it do: is_expected() |> to(have ncode: "n9876z")
    end
  end

  describe "User" do
    context "default value" do
      subject do: from(:user) |> Q.build |> shared.expand.()

      it do: is_expected() |> to(have uri:   "/userapi/api")
      it do: is_expected() |> to(have order: "new")
    end

    context "exec query" do
      subject do: from(:user, select: [:userid, :name1st], where: [minnovel: 1, maxnovel: 10], order: :old) |> Q.build |> shared.expand.()

      it do: is_expected() |> to(have uri:      "/userapi/api")
      it do: is_expected() |> to(have order:    "old")
      it do: is_expected() |> to(have of:       "u-1")
      it do: is_expected() |> to(have minnovel: "1")
      it do: is_expected() |> to(have maxnovel: "10")
    end
  end
end
