# NarouWrapper

NarouWrapper is an API wrapper for `小説家になろう`.

It can be written in `ElixirStyle`.

## Installation

```elixir
# mix.exs

def deps do
  [
    {:narou_wrapper, git: "https://github.com/harukikubota/narou_wrapper"}
  ]
end
```

## Usage

### [Novel Search API](https://dev.syosetu.com/man/api/)

```elixir
iex> use Narou
iex> Narou.init(%{type: :novel})
    |> select([:t, :w])
    |> where(ncode: "n2267be")
    |> Narou.run!

    {
      :ok,
      1,
      [
        %{
          title: => "Ｒｅ：ゼロから始める異世界生活",
          writer: => "鼠色猫/長月達平"
        }
      ]
    }

```

### [Ranking Search API](https://dev.syosetu.com/man/rankapi/)

```elixir
iex> use Narou
iex> Narou.init(%{type: :rank})
    |> where((y: 2020, m: 03, d: 31, t: :d)
    |> Narou.run!

    {
      :ok,
      [
        %{"ncode" => "N7378GC", "pt" => 4450, "rank" => 1},
        %{"ncode" => "N7529GB", "pt" => 4280, "rank" => 2},
        %{"ncode" => "N2361GC", "pt" => 3698, "rank" => 3},
        %{...},
        ...
    }

```

### [Rankin Search API](https://dev.syosetu.com/man/rankinapi/)

```elixir
iex> use Narou
iex> Narou.init(%{type: :rankin})
    |> where(ncode: "n2267be")
    |> Narou.run!

    {:ok,
      [
        %{pt: 90, rank: 103, rtype: "20130501-d"},
        %{pt: 4739, rank: 72, rtype: "20130501-m"},
        %{pt: 9947, rank: 86, rtype: "20130501-q"},
        %{...},
        ...
    }

```

### [User Search API](https://dev.syosetu.com/man/userapi/)

```elixir
iex> use Narou
iex> Narou.init(%{type: :user})
    |> select([:userid, :name, :yomikata])
    |> where(userid: 235132)
    |> Narou.run!

    {
      :ok,
      1,
      [
        %{
          name: "鼠色猫/長月達平",
          userid: 235132,
          yomikata: "ネズミイロネコ/ナガツキタッペイ"
        }
      ]
    }

```

---
## Other
`NarouWrapper`は非公式の製作物であり、株式会社ヒナプロジェクトが提供するものではありません。

APIサーバ等の更新などにより、本ライブラリが利用できなくなる場合があります。

---
## License

[MIT license](https://en.wikipedia.org/wiki/MIT_License).