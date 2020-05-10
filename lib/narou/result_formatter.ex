defmodule Narou.ResultFormatter do
@moduledoc """
    取得データの整形を行う。

  ## EXAMPLE
      defmodule MyFormatter do
        use Narou.ResultFormatter

        @param
          * :title  : 編集したいカラム名
          * old_val : 取得データの元の値

        @return 変更後の値を返す
        def update_by(:title, _), do: "this is new title."

        # 全てのカラムに対して待ち受けするパターンの宣言が必要。
        def update_by(_, old_val), do: old_val end
      end

      Narou.init |> Narou.run |> Narou.format_with(MyFormatter)

"""
  defmacro __using__(_opts) do
    quote do
      def update_by(:field_name, old_val) do old_val end
      defoverridable update_by: 2
    end
  end

  @spec exec(list(map), atom) :: list(map)
  def exec(result, format_mod \\ Narou.ResultFormatter.Default) do
    result
    |> Enum.map(fn x ->
      x |> Enum.map(fn {k,v} -> {k, format_mod.update_by(k, v)} end) |> Map.new
    end)
  end

  defmodule Default do
    @spec update_by(atom, any) :: any
    def update_by(:ncode, o) do String.downcase(o) end
    def update_by(_, old_val) do old_val end
  end
end
