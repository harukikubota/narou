defmodule Narou.Entity do
@moduledoc """
APIデータの基底モジュール。
"""

  import Narou.Util

@doc """
APIデータの共通処理。

## param
  - validate: list(symbol) : バリデーションを追加したいカラムリストを指定する。 [:st, :limit]
  - hoge_attr: default_val : 追加したいプロパティと初期値を指定する。

## EXAMPLE

  defmodule MyStruct
    use Narou.Entity, hoge: "", limit: 1, validate: [:limit]
  end
"""
  defmacro __using__(attributes) do
    quote do
      import Narou.Entity
      use Vex.Struct

      {validate_info, attributes} = Keyword.split(unquote(attributes), [:validate, :validate_use_value])

      [
        type: nil,
        out_type: :json,
        maximum_fetch_mode: false
      ] ++ attributes |> defstruct

      validates :type,     inclusion: Narou.Entity.api_types
      validates :out_type, inclusion: [:json]

      add_validate_cols = Keyword.get(validate_info, :validate) |> List.wrap()

      validations =
        [
          [:st,     number:    [greater_than_or_equal_to: 1, less_than_or_equal_to: 2000]],
          [:limit,  number:    [greater_than_or_equal_to: 1, less_than_or_equal_to: 500]],
          [:order,  inclusion: validate_info[:validate_use_value][:order]],
          [:select, by:        &valid_select?/1]
        ]

      Enum.each(validations, fn [key_name, opt] ->
        if Enum.member?(add_validate_cols, key_name), do: validates(key_name, List.wrap(opt))
      end)

      def __drop_keys__, do: [:__struct__, :maximum_fetch_mode]
      defoverridable __drop_keys__: 0
    end
  end

  @spec init(keyword()) :: {:ok, map()} | {:error, binary()}
  def init(opt) do
    {[type: type], opt} = Keyword.split(opt, [:type])

    if type in api_types() do
      gen_struct(type, opt) |> validate()
    else
      {:error, "Unexpected type `#{type}`."}
    end
  end

  defp gen_struct(type, opt) do
    to_submodule_name(type)
    |> struct(type: type)
    |> patch(opt)
  end

  defp to_submodule_name(type), do: Module.concat(__MODULE__, type |> to_string |> Macro.camelize |> String.to_atom)

  defp patch(struct, opt), do: Enum.reduce([:st, :limit, :maximum_fetch_mode], struct, &do_patch(&1, &2, opt[&1]))

  defp do_patch(:st,                 struct, st)    when is_integer(st),    do: %{struct | st: st}
  defp do_patch(:limit,              struct, limit) when is_integer(limit), do: %{struct | limit: limit}
  defp do_patch(:maximum_fetch_mode, struct, mode)  when is_boolean(mode) do
    if(mode, do: %{struct | limit: 500}, else: struct) |> Map.merge(%{maximum_fetch_mode: mode})
  end

  defp do_patch(:st,                 struct, _), do: struct
  defp do_patch(:limit,              struct, _), do: struct
  defp do_patch(:maximum_fetch_mode, struct, _), do: struct

  @doc """
      対応しているAPIタイプのリスト
  """
  @spec api_types() :: list(atom)
  def api_types(), do: [:novel, :rank, :rankin, :user]

  @spec validate(map) :: {:ok, map} | {:error, {:error, any}}
  def validate(s), do: if valid?(s), do: {:ok, s}, else: {:error, errors(s)}

  defp valid?(s) when is_struct(s), do: s.__struct__.valid?(s)

  defp errors(s), do: Vex.errors(s)

  def valid_select?(cols), do: Enum.all?(cols, &Narou.Util.is_symbol?/1)

  def to_map_for_build_query(entity), do: Map.drop(entity, to_submodule_name(entity.type).__drop_keys__)
end
