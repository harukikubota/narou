defmodule NarouSpec do
  use ESpec

  describe "Narou.init" do
    context "no option" do
      subject do: Narou.init

      # check common columns default value.
      it do: is_expected() |> to(have type: :novel)
      it do: is_expected() |> to(have out_type: :json)
      it do: is_expected() |> to(have maximum_fetch_mode: false)
    end

    context "bad param" do
      subject do: Narou.init type: :hoge
      it do: is_expected() |> to(be_error_result())
    end

    context "type novel good" do
      subject do: Narou.init type: :novel

      it do: is_expected() |> to(have type:   :novel)
      it do: is_expected() |> to(have limit:  20)
      it do: is_expected() |> to(have st:     1)
      it do: is_expected() |> to(have select: [])
      it do: is_expected() |> to(have where:  %{})
      it do: is_expected() |> to(have order:  :new)
    end

    context "type novel good for min" do
      subject do: Narou.init type: :novel, limit: 1
      it do: is_expected() |> to(have limit: 1)
    end

    context "type novel good for max" do
      subject do: Narou.init type: :novel, limit: 500, st: 2000

      it do: is_expected() |> to(have limit: 500)
      it do: is_expected() |> to(have st:    2000)
    end

    context "type novel good for maximum_fetch_mode" do
      subject do: Narou.init type: :novel, maximum_fetch_mode: true

      it do: is_expected() |> to(have maximum_fetch_mode: true)
      it do: is_expected() |> to(have limit: 500)
    end

    context "type novel bad lower limit" do
      subject do: Narou.init type: :novel, limit: 0, st: 0

      it do: is_expected() |> to(match_pattern {:error, [{:error, :limit, :number, "must be a number greater than or equal to 1"}, _]})
      it do: is_expected() |> to(match_pattern {:error, [_, {:error, :st, :number, "must be a number greater than or equal to 1"}]})
    end

    context "type novel bad over limit" do
      subject do: Narou.init type: :novel, limit: 501, st: 2001

      it do: is_expected() |> to(match_pattern {:error, [{:error, :limit, :number, "must be a number less than or equal to 500"}, _]})
      it do: is_expected() |> to(match_pattern {:error, [_, {:error, :st, :number, "must be a number less than or equal to 2000"}]})
    end

    context "type rank good" do
      subject do: Narou.init type: :rank

      it do: is_expected() |> to(have type: :rank)
      it do: is_expected() |> to(have where: %{y: 2013, m: 05, d: 01, t: :d})
    end

    context "type rankin good" do
      subject do: Narou.init type: :rankin

      it do: is_expected() |> to(have type: :rankin)
      it do: is_expected() |> to(have where: %{ncode: "N0000A"})
    end

    context "type user good" do
      subject do: Narou.init type: :user

      it do: is_expected() |> to(have type:   :user)
      it do: is_expected() |> to(have select: [])
      it do: is_expected() |> to(have where:  %{})
      it do: is_expected() |> to(have order:  :new)
    end
  end
end
