# NarouWrapper

`小説家になろう` API client wrapper.

It can be written in ElixirStyle.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `narou_wrapper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:narou_wrapper, "~> 0.1.0"}
  ]
end
```

## Usage

### [Novel Search API](https://dev.syosetu.com/man/api/)

```elixir
iex> use Narou
iex> Narou.init(type: :novel)
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
iex> Narou.init(type: :rank)
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

---
## Other
`NarouWrapper`は非公式の製作物であり、株式会社ヒナプロジェクトが提供するものではありません。

APIサーバ等の更新などにより、本ライブラリが利用できなくなる場合があります。

---
## License

[MIT license](https://en.wikipedia.org/wiki/MIT_License).