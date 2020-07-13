defmodule NarouQueryBuilderSpec do
  use ESpec
  alias Narou.QueryBuilder, as: Q
  use Narou.Query

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
      let :default_queries, do: Narou.init(type: :novel) |> Q.build |> shared.expand.()

      it do: expect default_queries() |> to(have uri:   "/novelapi/api")
      it do: expect default_queries() |> to(have lim:   "20")
      it do: expect default_queries() |> to(have order: "new")
      it do: expect default_queries() |> to(have st:    "1")
      it do: expect default_queries() |> to(have out:   "json")
    end

    context "exec query" do
      let! :s, do: Narou.init(type: :novel, limit: 500, st: 2000) |> select([:title, :writer]) |> where(ncode: "n1", userid: 1) |> order(:old) |> Q.build |> shared.expand.()

      it do: expect s() |> to(have uri:    "/novelapi/api")
      it do: expect s() |> to(have lim:    "500")
      it do: expect s() |> to(have st:     "2000")
      it do: expect s() |> to(have order:  "old")
      it do: expect s() |> to(have of:     "t-w")
      it do: expect s() |> to(have ncode:  "n1")
      it do: expect s() |> to(have userid: "1")
    end
  end

  describe "Rank" do
    context "default value" do
      let :default_queries, do: Narou.init(type: :rank) |> Q.build |> shared.expand.()

      it do: expect default_queries() |> to(have uri:   "/rank/rankget")
      it do: expect default_queries() |> to(have rtype: "20130501-d")
    end

    context "exec query" do
      let :exec, do: Narou.init(type: :rank) |> where(y: 2020, m: 12, d: 31, t: :m) |> Q.build |> shared.expand.()

      it do: expect exec() |> to(have rtype: "20201231-m")
    end
  end

  describe "Rankin" do
    context "default value" do
      let :default_queries, do: Narou.init(type: :rankin) |> Q.build |> shared.expand.()

      it do: expect default_queries() |> to(have uri:   "/rank/rankin")
      it do: expect default_queries() |> to(have ncode: "N0000A")
    end

    context "exec query" do
      let :exec, do: Narou.init(type: :rankin) |> where(ncode: "n9876z") |> Q.build |> shared.expand.()

      it do: expect exec() |> to(have ncode: "n9876z")
    end
  end

  describe "User" do
    context "default value" do
      let :default_queries, do: Narou.init(type: :user) |> Q.build |> shared.expand.()

      it do: expect default_queries() |> to(have uri:   "/userapi/api")
      it do: expect default_queries() |> to(have order: "new")
    end

    context "exec query" do
      let! :s, do: Narou.init(type: :user) |> select([:userid, :name1st]) |> where(minnovel: 1, maxnovel: 10) |> order(:old) |> Q.build |> shared.expand.()

      it do: expect s() |> to(have uri:      "/userapi/api")
      it do: expect s() |> to(have order:    "old")
      it do: expect s() |> to(have of:       "u-1")
      it do: expect s() |> to(have minnovel: "1")
      it do: expect s() |> to(have maxnovel: "10")
    end
  end
end
