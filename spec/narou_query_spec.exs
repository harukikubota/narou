defmodule NarouQuerySpec do
  use ESpec
  use Narou.Query

  describe "select" do
    context "novel good_param" do
      let :s,      do: Narou.init %{type: :novel}
      let :q_one,  do: s() |> select(:t)
      let :q_many, do: q_one() |> select([:w, :n])

      it do: expect q_one()  |> to(have select: [:t])
      it do: expect q_many() |> to(have select: [:t, :w, :n])
    end

    context "novel bad_param" do
      let :s,     do: Narou.init %{type: :novel}
      let :q_str, do: s() |> select("hoge")
      let :q_atm, do: s() |> select(Hoge)

      it do: expect q_str() |> to(be_error_result())
      it do: expect q_atm() |> to(be_error_result())
    end

    context "not_suppert types" do
      let :rank, do: Narou.init %{type: :rank}
      let :rank_q, do: rank() |> select(:a)

      it do: expect rank_q() |> to(be_error_result())
      it do: expect rank_q() |> elem(1) |> to(eq "The API type :rank does not support `select` queries.")
    end
  end

  describe "where" do
    context "novel good_param" do
      let :s,      do: Narou.init %{type: :novel}
      let :q_one,  do: s() |> where(ncode: "n2267be")
      let :q_many, do: q_one() |> where(userid: 1, genre: 1)

      it do: expect q_one()   |> Map.get(:where) |> to(have ncode:  "n2267be")
      it do: expect q_many()  |> Map.get(:where) |> to(have userid: 1)
      it do: expect q_many()  |> Map.get(:where) |> to(have genre:  1)
    end

    context "novel bad_param" , do: # pass

    context "rank good_param" do
      let :s,      do: Narou.init %{type: :rank}
      let :q_date, do: s() |> where(y: 2020, m: 12, d: 31)

      it do: expect q_date()  |> Map.get(:where) |> to(have y: 2020)
      it do: expect q_date()  |> Map.get(:where) |> to(have m: 12)
      it do: expect q_date()  |> Map.get(:where) |> to(have d: 31)

      it do: expect s() |> where(t: :d) |> Map.get(:where) |> to(have t: :d)
      it do: expect s() |> where(t: :w) |> Map.get(:where) |> to(have t: :w)
      it do: expect s() |> where(t: :m) |> Map.get(:where) |> to(have t: :m)
      it do: expect s() |> where(t: :q) |> Map.get(:where) |> to(have t: :q)
    end

    context "rank bad_param" do
      let :s,        do: Narou.init %{type: :rank}
      let :bad_date, do: s() |> where(y: 2020, m: 2, d: 31)
      let :bad_type, do: s() |> where(t: :hoge)
      let :bad_key,  do: s() |> where(hoge: :hoge)

      it do: expect bad_date() |> to(be_error_result())
      it do: expect bad_date() |> elem(1) |> Enum.at(0) |> elem(3) |> to(eq "invalid date.")

      it do: expect bad_type() |> to(be_error_result())
      it do: expect bad_type() |> elem(1) |> Enum.at(0) |> elem(3) |> to(have "must be one of [")

      it do: expect bad_key() |> to(be_error_result())
      it do: expect bad_type() |> elem(1) |> Enum.at(0) |> elem(3) |> to(have "must be one of [")
    end
  end

  describe "order" do
    context "novel good_param" do
      let :s,      do: Narou.init %{type: :novel}
      let :q_order,  do: s() |> order(:hyoka)
      let :override, do: s() |> order(:old)

      it do: expect q_order()  |> to(have order: :hyoka)
      it do: expect override() |> to(have order: :old)
    end

    context "novel bad_param" do
      let :s,       do: Narou.init %{type: :novel}
      let :bad_key, do: s() |> order(:hoge)
      let :bad_val, do: s() |> order("hoge")

      it do: expect bad_key() |> to(be_error_result())
      it do: expect bad_val() |> to(be_error_result())
    end

    context "not_suppert types" do
      let :rank, do: Narou.init %{type: :rank}
      let :rank_q, do: rank() |> order(:not)

      it do: expect rank_q() |> to(be_error_result())
      it do: expect rank_q() |> elem(1) |> to(eq "The API type :rank does not support `order` queries.")
    end
  end
end
