defmodule NarouQuerySpec do
  use ESpec
  use Narou.Query

  describe "from" do
    context "from good_param default" do
      subject do: from :novel

      it do: is_expected() |> to(have type: :novel)
    end

    context "from good_param with initialize option" do
      subject do: from :novel, limit: 10, st: 10

      it do: is_expected() |> to(have limit: 10)
      it do: is_expected() |> to(have st:    10)
    end

    context "from good_param with query" do
      subject do: from :novel, select: [:t], where: [ncode: "n2267be"], order: :old

      it do: is_expected() |> to(have select: [:t])
      it do: is_expected() |> to(have where:  %{ncode: "n2267be"})
      it do: is_expected() |> to(have order:  :old)
    end
  end

  describe "select" do
    context "novel good_param" do
      let! :s,     do: from :novel
      let :q_one,  do: s()     |> select(:t)
      let :q_many, do: q_one() |> select([:w, :n])

      it do: expect q_one()  |> to(have select: [:t])
      it do: expect q_many() |> to(have select: [:t, :w, :n])
    end

    context "novel bad_param" do
      let! :s,    do: from :novel
      let :q_str, do: s() |> select("hoge")
      let :q_atm, do: s() |> select(Hoge)

      it do: expect q_str() |> to(be_error_result())
      it do: expect q_atm() |> to(be_error_result())
    end

    context "user good_param" do
      let! :s,     do: from :user
      let :q_one,  do: s()     |> select(:n)
      let :q_many, do: q_one() |> select([:u, :y])

      it do: expect q_one()  |> to(have select: [:n])
      it do: expect q_many() |> to(have select: [:n, :u, :y])
    end

    context "user bad_param" do
      let! :s,    do: from :user
      let :q_str, do: s() |> select("hoge")
      let :q_atm, do: s() |> select(Hoge)

      it do: expect q_str() |> to(be_error_result())
      it do: expect q_atm() |> to(be_error_result())
    end

    context "not_suppert types" do
      subject do: from(:rank) |> select(:a)

      it do: is_expected() |> to(match_pattern {:error, "The API type :rank does not support `select` queries."})
    end
  end

  describe "where" do
    context "novel good_param" do
      let! :s,     do: from :novel
      let :q_one,  do: s()     |> where(ncode: "n2267be")
      let :q_many, do: q_one() |> where(userid: 1, genre: 1)

      it do: expect q_one()   |> Map.get(:where) |> to(have ncode:  "n2267be")
      it do: expect q_many()  |> Map.get(:where) |> to(have userid: 1)
      it do: expect q_many()  |> Map.get(:where) |> to(have genre:  1)
    end

    # context "novel bad_param" , do: # pass

    context "rank good_param" do
      let :s,      do: from :rank
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
      let! :s,       do: from :rank
      let :bad_date, do: s() |> where(y: 2020, m: 2, d: 31)
      let :bad_type, do: s() |> where(t: :hoge)
      let :bad_key,  do: s() |> where(hoge: :hoge)

      it do: expect bad_date() |> to(match_pattern {:error, [{:error, :where, :by, "invalid date."}]})
      it do: expect bad_type() |> to(match_pattern {:error, [{:error, :where, :by, "must be one of [:d, :w, :m, :q]"}]})
      it do: expect bad_key()  |> to(match_pattern {:error, [{:error, :where, :by, "Unexpected keys [:hoge]"}]})
    end

    context "rankin good_param" do
      let! :s,    do: from :rankin
      let :large, do: s() |> where(ncode: "N1234ABC")
      let :small, do: s() |> where(ncode: "n0956z")

      it do: expect large() |> Map.get(:where) |> to(have ncode: "N1234ABC")
      it do: expect small() |> Map.get(:where) |> to(have ncode: "n0956z")
    end

    context "rankin bad_param" do
      subject do: from(:rankin) |> where(ncode: "NHOGEHOGE")

      it do: is_expected() |> to(match_pattern {:error, [{:error, :where, :by, "invalid NCode `NHOGEHOGE`."}]})
    end

    context "user good_param" do
      let! :s,     do: from :user
      let :q_one,  do: s()     |> where(userid: 123456)
      let :q_many, do: q_one() |> where(name1st: "あ", minnovel: 1)

      it do: expect q_one()   |> Map.get(:where) |> to(have userid: 123456)
      it do: expect q_many()  |> Map.get(:where) |> to(have name1st: "あ")
      it do: expect q_many()  |> Map.get(:where) |> to(have minnovel: 1)
    end

    # context "user bad_param" , do: # pass
  end

  describe "order" do
    context "novel good_param" do
      let! :s,        do: from :novel
      let :q_order,   do: s() |> order(:hyoka)
      let :overrided, do: s() |> order(:old)

      it do: expect q_order()   |> to(have order: :hyoka)
      it do: expect overrided() |> to(have order: :old)
    end

    context "novel bad_param" do
      let! :s,      do: from :novel
      let :bad_key, do: s() |> order(:hoge)
      let :bad_val, do: s() |> order("hoge")

      it do: expect bad_key() |> to(be_error_result())
      it do: expect bad_val() |> to(be_error_result())
    end

    context "user good_param" do
      let! :s,        do: from :user
      let :q_order,   do: s() |> order(:novelcnt)
      let :overrided, do: s() |> order(:old)

      it do: expect q_order()   |> to(have order: :novelcnt)
      it do: expect overrided() |> to(have order: :old)
    end

    context "novel bad_param" do
      let! :s,      do: from :novel
      let :bad_key, do: s() |> order(:hoge)
      let :bad_val, do: s() |> order("hoge")

      it do: expect bad_key() |> to(be_error_result())
      it do: expect bad_val() |> to(be_error_result())
    end

    context "not_suppert types" do
      subject do: from(:rank) |> order(:not)

      it do: is_expected() |> to(match_pattern {:error, "The API type :rank does not support `order` queries."})
    end
  end
end
