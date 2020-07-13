defmodule NarouSpec do
  use ESpec

  describe "Narou.init" do
    context "no option" do
      let! :s, do: Narou.init

      # check common columns default value.
      it do: expect s() |> to(have type: :novel)
      it do: expect s() |> to(have out_type: :json)
      it do: expect s() |> to(have maximum_fetch_mode: false)
    end

    context "bad param" do
      let :bad_type, do: Narou.init type: :hoge
      it do: expect bad_type()            |> to(be_error_result())
    end

    context "type novel good" do
      let! :s,     do: Narou.init type: :novel
      let :smin,   do: Narou.init type: :novel, limit: 1
      let :smax,   do: Narou.init type: :novel, limit: 500, st: 2000
      let :m_mode, do: Narou.init type: :novel, maximum_fetch_mode: true

      it do: expect s()      |> to(have type:   :novel)
      it do: expect s()      |> to(have limit:  20)
      it do: expect s()      |> to(have st:     1)
      it do: expect s()      |> to(have select: [])
      it do: expect s()      |> to(have where:  %{})
      it do: expect s()      |> to(have order:  :new)
      it do: expect smin()   |> to(have limit:  1)
      it do: expect smax()   |> to(have limit:  500)
      it do: expect smax()   |> to(have st:     2000)
      it do: expect m_mode() |> to(have maximum_fetch_mode: true)
      it do: expect m_mode() |> to(have limit:  500)
    end

    context "type novel bad" do
      let! :min,            do: Narou.init type: :novel, limit: 0, st: 0
      let :limit_error_mes, do: min() |> elem(1) |> Enum.at(0)
      let :st_error_mes,    do: min() |> elem(1) |> Enum.at(1)

      let! :over_max,         do: Narou.init type: :novel, limit: 501, st: 2001
      let :limit_o_error_mes, do: over_max() |> elem(1) |> Enum.at(0)
      let :st_o_error_mes,    do: over_max() |> elem(1) |> Enum.at(1)

      it do: expect min()                          |> to(be_error_result())
      it do: expect limit_error_mes()   |> elem(1) |> to(eq :limit)
      it do: expect limit_error_mes()   |> elem(3) |> to(eq "must be a number greater than or equal to 1")
      it do: expect st_error_mes()      |> elem(1) |> to(eq :st)
      it do: expect st_error_mes()      |> elem(3) |> to(eq "must be a number greater than or equal to 1")

      it do: expect over_max()                     |> to(be_error_result())
      it do: expect limit_o_error_mes() |> elem(1) |> to(eq :limit)
      it do: expect limit_o_error_mes() |> elem(3) |> to(eq "must be a number less than or equal to 500")
      it do: expect st_o_error_mes()    |> elem(1) |> to(eq :st)
      it do: expect st_o_error_mes()    |> elem(3) |> to(eq "must be a number less than or equal to 2000")

    end

    context "type rank good" do
      let! :s, do: Narou.init type: :rank

      it do: expect s() |> to(have type: :rank)
      it do: expect s() |> to(have where: %{y: 2013, m: 05, d: 01, t: :d})
    end

    context "type rankin good" do
      let! :s, do: Narou.init type: :rankin

      it do: expect s() |> to(have type: :rankin)
      it do: expect s() |> to(have where: %{ncode: "N0000A"})
    end

    context "type user good" do
      let! :s,   do: Narou.init type: :user

      it do: expect s()    |> to(have type:   :user)
      it do: expect s()    |> to(have select: [])
      it do: expect s()    |> to(have where:  %{})
      it do: expect s()    |> to(have order:  :new)
    end
  end
end
